---@type MeoSpec
local Spec = { "mini.icons", lazy = false, priority = 90 }

Spec.config = function()
  local miniicons = require("mini.icons")
  miniicons.setup()
end

return Spec
