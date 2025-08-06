---@type MeoSpec
local Spec = { "mini.icons", lazy = false, priority = 90 }

Spec.config = function()
  local miniicons = require("mini.icons")
  miniicons.setup()
  miniicons.mock_nvim_web_devicons()
  -- NOTE: it requires to (implicitly) load several modules to modify LSP
  -- kinds, which slows down the startup, so we defer the setup.
  MiniDeps.later(function() miniicons.tweak_lsp_kind("replace") end)
end

return Spec
