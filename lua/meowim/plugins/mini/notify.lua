---@type MeoSpec
local Spec = { "mini.notify", lazy = false, priority = 95 }

Spec.config = function()
  local mininotify = require("mini.notify")
  mininotify.setup()
  vim.notify = mininotify.make_notify()
end

return Spec
