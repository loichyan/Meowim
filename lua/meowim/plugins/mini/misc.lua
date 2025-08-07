---@type MeoSpec
local Spec = { "mini.misc", event = "VeryLazy" }
local M = {}

Spec.config = function()
  local minimisc = require("mini.misc")
  minimisc.setup({ make_global = { "put", "put_text", "bench_time", "stat_summary" } })
  minimisc.setup_restore_cursor()

  -- Setup auto root directory discovery
  local root_patterns = { ".git" }
  vim.o.autochdir = false
  Meow.autocmd("meowim.plugins.mini.misc", {
    {
      event = "BufEnter",
      desc = "Find root and change current directory",
      nested = true,
      callback = vim.schedule_wrap(function(data)
        if data.buf ~= vim.api.nvim_get_current_buf() then return end
        -- Ignore non-file buffers
        if vim.bo.buftype ~= "" then return end
        local root = MiniMisc.find_root(data.buf, root_patterns)
        if root ~= nil then vim.fn.chdir(root) end
      end),
    },
  })
end

---Zooms in/out current buffer.
function M.zoom()
  local title = " Zoom |" .. vim.fn.expand(".") .. " "
  require("mini.misc").zoom(0, { title = title })
  -- Differentiate between zooming in and zooming out
  -- See <https://github.com/echasnovski/mini.nvim/issues/1911#issuecomment-3112985891>
  if vim.api.nvim_win_get_config(0).relative ~= "" then
    vim.wo.winhighlight = "NormalFloat:Normal"
  end
end

M[1] = Spec
return M
