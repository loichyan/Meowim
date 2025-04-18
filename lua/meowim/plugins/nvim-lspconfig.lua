---@type MeoSpec
return {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    config = function()
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

        local lspconfig, cmp = require("lspconfig"), require("blink-cmp")
        for name, config in pairs(servers) do
            config.capabilities = cmp.get_lsp_capabilities(config.capabilities)
            lspconfig[name].setup(config)
        end
    end,
    dependencies = { "blink.cmp" },
}
