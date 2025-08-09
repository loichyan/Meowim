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
          workspace = { checkThirdParty = false },
          completion = { callSnippet = "Replace" },
        },
      },
    },
  }

  for name, config in pairs(servers) do
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
  end
end

return Spec
