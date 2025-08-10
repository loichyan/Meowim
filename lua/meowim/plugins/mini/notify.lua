---@type MeoSpec
local Spec = { "mini.notify", lazy = false, priority = 95 }

Spec.config = function()
  local mininotify = require("mini.notify")
  mininotify.setup({
    window = {
      config = function()
        local screen = math.floor(0.5 * vim.o.columns)
        return { width = math.min(screen, 50) }
      end,
    },
  })
  vim.notify = mininotify.make_notify()
end

return Spec
