---@type MeoSpec
local Spec = { "mini.statusline", event = "UIEnter" }

Spec.config = function()
  local ministl = require("mini.statusline")

  ---@type table<vim.diagnostic.Severity,integer>
  local diagnostic_counts = {}
  local cmdheight_was_zero
  Meow.autocmd("meowim.plugins.mini.statusline", {
    {
      event = "DiagnosticChanged",
      desc = "Track workspace diagnostics",
      callback = function()
        diagnostic_counts = {}
        for _, diag in ipairs(vim.diagnostic.get()) do
          diagnostic_counts[diag.severity] = (diagnostic_counts[diag.severity] or 0) + 1
        end
      end,
    },
    {
      event = { "CmdlineEnter", "CmdlineLeave" },
      desc = "Show statusline when in cmdline",
      callback = function(ev)
        if ev.event == "CmdlineEnter" then
          if vim.o.cmdheight ~= 0 then return end
          vim.o.cmdheight = 1
          cmdheight_was_zero = true
        elseif cmdheight_was_zero then
          -- Suppress statusline redrawing when typing in cmdline.
          vim.o.cmdheight = 0
          cmdheight_was_zero = nil
        end
      end,
    },
  })

  -- stylua: ignore
  local diff_sections = {
    { "n_ranges", "#", "diffLine"    },
    { "add",      "+", "diffAdded"   },
    { "change",   "~", "diffChanged" },
    { "delete",   "-", "diffRemoved" },
  }

  -- stylua: ignore
  local diagnostic_sections = {
    { vim.diagnostic.severity.ERROR, "E", "DiagnosticError" },
    { vim.diagnostic.severity.WARN,  "W", "DiagnosticWarn"  },
    { vim.diagnostic.severity.INFO,  "I", "DiagnosticInfo"  },
    { vim.diagnostic.severity.HINT,  "H", "DiagnosticHint"  },
  }

  -- Eviline-like statusline
  local last_cwd, last_file, last_buf = vim.fn.getcwd(), 0, 0
  local active = function()
    local groups = {}
    local add = function(hi, string)
      if string == "" then
        return
      elseif hi == nil then
        groups[#groups] = groups[#groups] .. string
      else
        table.insert(groups, "%#" .. hi .. "#" .. string)
      end
    end

    local _, mode_hl = ministl.section_mode({})
    add(mode_hl, " %##")

    local buf = vim.api.nvim_get_current_buf()
    if vim.o.buftype == "" then
      last_cwd = vim.fn.getcwd()
      last_file = buf
      last_buf = buf
    else
      last_file = vim.api.nvim_buf_is_valid(last_file) and last_file or buf
      -- Display the filename anyway for buffers open with splits or tabs.
      if vim.api.nvim_win_get_config(0).relative == "" then
        last_buf = buf
      else
        last_buf = vim.api.nvim_buf_is_valid(last_buf) and last_buf or buf
      end
    end

    ----------------------
    --- Project status ---
    ----------------------
    local project = vim.fn.fnamemodify(last_cwd, ":t")
    local git_summary = vim.b[last_file].minigit_summary
    if git_summary and git_summary.head_name then
      local head = git_summary.head_name
      head = head == "HEAD" and git_summary.head:sub(1, 7) or head
      add("gitcommitBranch", " " .. project .. ":" .. head)
    else
      add("gitcommitBranch", " " .. project)
    end

    -----------------------
    --- Macro Recording ---
    -----------------------
    local macro_rec = vim.fn.reg_recording()
    if macro_rec ~= "" then add("Function", "󰵝 Recording @" .. macro_rec) end

    -----------------------------
    --- Workspace diagnostics ---
    -----------------------------
    for _, sec in ipairs(diagnostic_sections) do
      local count = diagnostic_counts[sec[1]]
      if count then add(sec[3], string.format("%s%d", sec[2], count)) end
    end

    -------------
    --- Git Diffs
    -------------
    local git_diff = vim.b[last_file].minidiff_summary
    if git_diff then
      for _, sec in ipairs(diff_sections) do
        local count = git_diff[sec[1]]
        if count and count ~= 0 then add(sec[3], string.format("%s%d", sec[2], count)) end
      end
    end

    ----------------
    --- Filename ---
    ----------------
    local filename = vim.api.nvim_buf_get_name(last_buf)
    local bo = vim.bo[last_buf]
    if bo.buftype == "terminal" then
      filename = vim.fn.fnamemodify(filename, ":t")
    else
      local mods = ministl.is_truncated(80) and ":t" or ":~:."
      filename = vim.fn.fnamemodify(filename, mods)
        .. (bo.modified and "[+]" or not bo.modifiable and "[-]" or "")
        .. (bo.readonly and "[RO]" or "")
    end
    add("", filename:gsub("%%", "%%%%"))

    add(nil, "%<%=") -- End left section

    ------------------
    --- File infos ---
    ------------------
    add("", ministl.section_lsp({ trunc_width = 100 }))
    add("", ministl.section_fileinfo({ trunc_width = 120 }))

    local searchcount = ministl.section_searchcount({})
    if searchcount ~= "" then add("String", " Search " .. searchcount) end

    add("Constant", "%3l|%2v")

    add(mode_hl, " %##")

    return table.concat(groups, " ")
  end

  ministl.setup({
    content = {
      active = active,
      inactive = function() end,
    },
  })
end

return Spec
