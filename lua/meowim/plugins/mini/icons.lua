---@type MeoSpec
return {
  "mini.icons",
  lazy = false,
  priority = 90,
  config = function()
    local icons = require("mini.icons")
    icons.setup()
    icons.mock_nvim_web_devicons()
    -- NOTE: it requires to (implicitly) load several modules to modify LSP
    -- kinds, which slows down the startup, so we defer the setup.
    MiniDeps.later(function() icons.tweak_lsp_kind("replace") end)
  end,
}
