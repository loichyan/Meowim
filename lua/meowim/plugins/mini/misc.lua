---@type MeoSpec
local Spec = { "mini.misc", event = "VeryLazy" }
local M = {}

Spec.config = function()
  local minimisc = require("mini.misc")
  minimisc.setup({ make_global = { "put", "put_text", "bench_time", "stat_summary" } })
  minimisc.setup_restore_cursor()
  minimisc.setup_auto_root({ ".git" })

  -- TODO: report to mini.misc?
  -- Ensure target for `find_root` is a valid buffer
  local orig_find_root = minimisc.find_root
  ---@diagnostic disable-next-line: duplicate-set-field
  minimisc.find_root = function(bufnr, ...)
    bufnr = bufnr or 0
    if not Meowim.utils.is_valid_buf(bufnr) then return end
    return orig_find_root(bufnr, ...)
  end
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
