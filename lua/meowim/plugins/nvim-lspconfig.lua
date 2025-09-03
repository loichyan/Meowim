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
          diagnostics = {
            -- Don't analyze whole workspace, as it can be very slow
            workspaceDelay = -1,
          },
          workspace = {
            -- Don't analyze 3rd party codb
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
  vim.lsp.config("*", { capabilities = require("mini.completion").get_lsp_capabilities() })
end

return Spec
