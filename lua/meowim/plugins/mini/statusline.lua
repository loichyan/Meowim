---@type MeoSpec
local Spec = { "mini.statusline", event = "UIEnter" }
local H = {}

Spec.config = function()
  local MiniStatusline = require("mini.statusline")

  MiniStatusline.setup({
    content = {
      active = H.active,
      inactive = function() end,
    },
  })

  H.patch_prompt()
  Meow.autocmd("meowim.plugins.mini.statusline", {
    {
      event = "DiagnosticChanged",
      desc = "Track workspace diagnostics",
      callback = H.track_diagnostics,
    },
    {
      event = { "CmdlineEnter", "CmdlineLeave" },
      desc = "Show statusline when in cmdline",
      callback = H.auto_cmdheight,
    },
  })
end

-- stylua: ignore
H.diff_sections = {
  { "n_ranges", "#", "diffLine"    },
  { "add",      "+", "diffAdded"   },
  { "change",   "~", "diffChanged" },
  { "delete",   "-", "diffRemoved" },
}

-- stylua: ignore
H.diagnostic_sections = {
  { vim.diagnostic.severity.ERROR, "E", "DiagnosticError" },
  { vim.diagnostic.severity.WARN,  "W", "DiagnosticWarn"  },
  { vim.diagnostic.severity.INFO,  "I", "DiagnosticInfo"  },
  { vim.diagnostic.severity.HINT,  "H", "DiagnosticHint"  },
}

-- Eviline-like statusline
H.last_active = {} -- track last visited buffer
H.git_summary = {} -- cache git summary per cwd
function H.active()
  local groups = {}
  local add = function(hi, string)
    if string == "" then
      return
    else
      table.insert(groups, "%#" .. hi .. "#" .. string)
    end
  end

  local _, mode_hl = MiniStatusline.section_mode({})
  add(mode_hl, " %##")

  -- Track info about last visited buffer:
  -- * last workspace directory
  -- * last ordinary file
  -- * last non-foating buffer
  local last = H.last_active
  local buf = vim.api.nvim_get_current_buf()
  if not last.cwd or vim.bo[buf].buftype == "" then
    last.cwd = vim.fn.getcwd()
    last.file = buf
    last.buf = buf
  else
    last.file = vim.api.nvim_buf_is_valid(last.file) and last.file or buf
    -- Hide the filename of floating windows.
    if vim.api.nvim_win_get_config(0).relative == "" then
      last.buf = buf
    else
      last.buf = vim.api.nvim_buf_is_valid(last.buf) and last.buf or buf
    end
  end

  ----------------------
  --- Project status ---
  ----------------------
  local project = vim.fn.fnamemodify(last.cwd, ":t")
  local git_summary = vim.b[last.file].minigit_summary or {}
  git_summary = not git_summary.head and H.git_summary[last.cwd] or git_summary

  -- branch name or a detached head
  if git_summary.head then
    H.git_summary[last.cwd] = git_summary
    local head = git_summary.head_name or "HEAD"
    head = head == "HEAD" and git_summary.head:sub(1, 7) or head
    head = head:gsub("^heads/", "") -- remove `heads/` prefixes
    project = project .. ":" .. head
  end

  -- rebasing, merging, etc.
  local in_progress = git_summary.in_progress or ""
  if in_progress ~= "" then project = project .. "|" .. in_progress end

  add("gitcommitBranch", " " .. project)

  -----------------------
  --- Macro Recording ---
  -----------------------
  local macro_rec = vim.fn.reg_recording()
  if macro_rec ~= "" then add("Function", "󰵝 Recording @" .. macro_rec) end

  -----------------------------
  --- Workspace diagnostics ---
  -----------------------------
  for _, sec in ipairs(H.diagnostic_sections) do
    local count = H.diagnostic_counts[sec[1]]
    if count then add(sec[3], string.format("%s%d", sec[2], count)) end
  end

  -------------
  --- Git Diffs
  -------------
  local git_diff = vim.b[last.file].minidiff_summary
  if git_diff then
    for _, sec in ipairs(H.diff_sections) do
      local count = git_diff[sec[1]]
      if count and count ~= 0 then add(sec[3], string.format("%s%d", sec[2], count)) end
    end
  end

  ----------------
  --- Filename ---
  ----------------
  local filename = vim.api.nvim_buf_get_name(last.buf)
  local bo = vim.bo[last.buf]
  if bo.buftype == "terminal" then
    filename = vim.fn.fnamemodify(filename, ":t")
  else
    local mods = MiniStatusline.is_truncated(80) and ":t" or ":~:."
    filename = vim.fn.fnamemodify(filename, mods)
      .. (bo.modified and "[+]" or not bo.modifiable and "[-]" or "")
      .. (bo.readonly and "[RO]" or "")
  end
  add("", filename:gsub("%%", "%%%%"))

  -------------------------
  --- Cmdline Messages  ---
  -------------------------
  add("", "%<%=") -- End left section
  add("", vim.o.showcmdloc == "statusline" and "%S" or "") -- 'showcmd'

  ------------------
  --- File infos ---
  ------------------

  add("", MiniStatusline.section_lsp({ trunc_width = 100 }))
  add("", MiniStatusline.section_fileinfo({ trunc_width = 120 }))

  local searchcount = MiniStatusline.section_searchcount({})
  if searchcount ~= "" then add("String", " Search " .. searchcount) end

  add("Constant", "%3l|%2v")

  add(mode_hl, " %##")

  return table.concat(groups, " ")
end

H.diagnostic_counts = {}
function H.track_diagnostics()
  H.diagnostic_counts = {}
  for _, diag in ipairs(vim.diagnostic.get()) do
    H.diagnostic_counts[diag.severity] = (H.diagnostic_counts[diag.severity] or 0) + 1
  end
end

H.cmdline_was_hidden = nil
function H.auto_cmdheight(ev)
  if ev.event == "CmdlineEnter" then
    if vim.o.cmdheight ~= 0 then return end
    vim.o.cmdheight = 1
    H.cmdline_was_hidden = true
  elseif H.cmdline_was_hidden then
    -- Suppress statusline redrawing when typing in cmdline.
    vim.o.cmdheight = 0
    H.cmdline_was_hidden = false
  end
end

---Keeps the statusline when prompting for user input.
---@diagnostic disable-next-line: duplicate-set-field
function H.patch_prompt()
  local wrap_fn = Meowim.utils.wrap_fn

  local was_hidden = false
  -- If there are prompts, show the cmdline before really displaying them.
  -- This method should work with most mini modules.
  local wrap_echo = function(echo, ...)
    if vim.o.cmdheight == 0 then
      was_hidden = true
      vim.o.cmdheight = 1
      vim.cmd("redraw")
    end
    return echo(...)
  end
  local wrap_getchar = function(getchar, ...)
    local echo = vim.api.nvim_echo
    vim.api.nvim_echo = wrap_fn(echo, wrap_echo)
    local ok, res = pcall(getchar, ...)
    vim.api.nvim_echo = echo

    if was_hidden then vim.o.cmdheight = 0 end
    return not ok and error(res) or res
  end

  vim.fn.getchar = Meowim.utils.wrap_fn(vim.fn.getchar, wrap_getchar)
  vim.fn.getcharstr = Meowim.utils.wrap_fn(vim.fn.getcharstr, wrap_getchar)

  -- `input()` always displays a prompt during execution, hence the patch is
  -- much easier.
  local wrap_input = function(input, ...)
    local should_display = vim.o.cmdheight == 0
    if should_display then vim.o.cmdheight = 1 end
    local ok, res = pcall(input, ...)

    if should_display then vim.o.cmdheight = 0 end
    return not ok and error(res) or res
  end
  vim.fn.input = wrap_fn(vim.fn.input, wrap_input)
end

return Spec
