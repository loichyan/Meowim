---@type MeoSpec
return {
    "mini.completion",
    event = "LazyFile",
    config = function()
        vim.o.completeopt = "menuone,noinsert,fuzzy"
        local completion = require("mini.completion")
        completion.setup({
            window = {
                info = { border = "solid" },
                signature = { border = "solid" },
            },
            -- stylua: ignore
            mappings = {
                force_twostep  = "<C-Space>",
                force_fallback = "<M-Space>",
                scroll_down    = "<C-f>",
                scroll_up      = "<C-b>",
            },
        })
        vim.lsp.config("*", { capabilities = MiniCompletion.get_lsp_capabilities() })
    end,
    dependencies = { "mini.snippets" },
}
