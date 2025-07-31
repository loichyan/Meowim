local Pickers = {}

local get_config = function()
  return vim.tbl_deep_extend("force", MiniPick.config, vim.b.minipick_config or {})
end

---Shows items with icons.
local show_with_icons = function(bufnr, items, query, opts)
  return MiniPick.default_show(
    bufnr,
    items,
    query,
    vim.tbl_extend("force", { show_icons = true }, opts or {})
  )
end

---Lists files with a sensible picker.
---@param local_opts? {hidden:boolean}
function Pickers.smart_files(local_opts, opts)
  local_opts = vim.tbl_extend("force", { hidden = false }, local_opts or {})
  local cwd = vim.fn.getcwd()
  local command, postprocess

  if local_opts.hidden then
    command = { "rg", "--files", "--no-follow", "--color=never", "--no-ignore" }
  elseif require("meowim.utils").get_git_repo(cwd) == cwd then
    command = {
      "git",
      "-c",
      "core.quotepath=false",
      "ls-files",
      "--exclude-standard",
      "--cached",
      "--others",
      "--deduplicate",
    }
    ---Filters out missing files.
    postprocess = function(items)
      return vim.tbl_filter(
        function(item) return item ~= "" and vim.uv.fs_stat(item) ~= nil end,
        items
      )
    end
  else
    command = { "rg", "--files", "--no-follow", "--color=never" }
  end

  opts = vim.tbl_deep_extend("force", {
    source = {
      name = "Files",
      cwd = cwd,
      show = (get_config().source or {}).show or show_with_icons,
    },
  }, opts or {})
  MiniPick.builtin.cli({ command = command, postprocess = postprocess }, opts)
end

---Lists all todo comments of the specified keywords.
---@param opts? {scope:"current"|"all",keywords:string[]}
function Pickers.todo(opts)
  opts = vim.tbl_extend("force", { keywords = { "TODO", "FIXME" } }, opts or {})
  local keywords = table.concat(opts.keywords, "|")
  require("mini.pick").builtin.grep({
    pattern = "\\b(" .. keywords .. ")(\\(.*\\))?:\\s+.+",
    globs = opts.scope == "current" and { vim.fn.expand("%") } or nil,
  }, {
    source = { name = keywords },
  })
end

---Lists notifications from mini.notify.
-- TODO: contribute to mini.extra
---@param local_opts {source:string[]}
function Pickers.notify(local_opts, opts)
  local_opts = vim.tbl_extend("force", { source = { "vim.notify" } }, local_opts or {})

  local notify = require("mini.notify")
  local notify_config = vim.tbl_deep_extend("force", notify.config, vim.b.mininotify_config or {})
  local format = notify_config.format or notify.default_format

  local items = {}
  for _, notif in pairs(notify.get_all()) do
    if vim.tbl_contains(local_opts.source, notif.data.source) then
      table.insert(items, { _orig = notif, text = vim.split(format(notif), "\n")[1] })
    end
  end
  -- Sort from oldest to newest.
  table.sort(items, function(a, b) return a._orig.ts_update < b._orig.ts_update end)

  opts = vim.tbl_deep_extend("force", {
    source = {
      name = "Notifications",
      items = items,
      preview = function(buf_id, item)
        vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, vim.split(item._orig.msg, "\n"))
      end,
      choose = function(item)
        vim.schedule(function() vim.print(item._orig) end)
      end,
    },
  }, opts or {})
  MiniPick.start(opts)
end

---Lists registered autocmds.
-- TODO: contribute to mini.extra
function Pickers.autocmds(local_opts, opts)
  -- stylua: ignore
  local fields = {
    { "group_name", "%-30s" },
    { "event",      "%-20s" },
    { "pattern",    "%-25s" },
    { "desc",       "%s"    },
  }
  local format = function(autocmd)
    return table.concat(
      vim.tbl_map(function(f) return string.format(f[2], autocmd[f[1]] or "") end, fields)
    )
  end

  local items = vim.tbl_map(
    function(autocmd) return { _orig = autocmd, text = format(autocmd) } end,
    vim.api.nvim_get_autocmds(local_opts or {})
  )
  -- Sort by group, then event
  table.sort(items, function(a, b)
    if not a._orig.group then
      return false
    elseif not b._orig.group then
      return true
    elseif a._orig.group == b._orig.group then
      return a._orig.event < b._orig.event
    else
      return a._orig.group < b._orig.group
    end
  end)

  opts = vim.tbl_deep_extend("force", {
    source = {
      name = "Autocmds",
      items = items,
      preview = function(buf_id, item)
        vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, vim.split(vim.inspect(item._orig), "\n"))
      end,
      choose = function(item)
        vim.schedule(function() vim.print(item._orig) end)
      end,
    },
  }, opts or {})
  MiniPick.start(opts)
end

return Pickers
