---@type MeoSpec
local Spec = { "mini.misc", event = "VeryLazy" }
local M = { Spec }

Spec.config = function()
  local minimisc = require("mini.misc")
  minimisc.setup({ make_global = { "put", "put_text", "bench_time", "stat_summary" } })
  minimisc.setup_restore_cursor()
end

---Zooms in/out current buffer.
M.zoom = function()
  local title = "Zoom | " .. vim.fn.expand("%:.")
  if not require("mini.misc").zoom(0, { title = title }) then return end
  vim.wo.winbar = " %#ZoomTitle#" .. string.gsub(title, "%%", "%%%%") .. "%##%="
  vim.wo.winhighlight = "NormalFloat:Normal"
end

return M
