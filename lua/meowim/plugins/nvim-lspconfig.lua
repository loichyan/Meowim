---@type MeoSpec
local Spec = { "neovim/nvim-lspconfig", event = "VeryLazy" }

Spec.config = function()
  ---@module "lspconfig"
  ---@type lspconfig.Config
  ---@diagnostic disable-next-line:missing-fields
  local servers = {
    lua_ls = {
      settings = {
        Lua = {
          completion = { callSnippet = "Replace" },
          workspace = {
            -- Don't analyze 3rd party library
            checkThirdParty = false,
            ignoreSubmodules = true,
          },
          telemetry = { enable = false },
        },
      },
    },
  }

  for name, config in pairs(servers) do
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
  end
  Meow.load("blink.cmp")
  vim.lsp.config("*", { capabilities = require("blink-cmp").get_lsp_capabilities() })
end

return Spec
