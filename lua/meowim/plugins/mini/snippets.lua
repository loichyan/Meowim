---@type MeoSpec
return {
    "mini.snippets",
    event = "VeryLazy",
    config = function()
        local snippets = require("mini.snippets")
        snippets.setup({
            snippets = {
                snippets.gen_loader.from_lang(),
            },
            mappings = {
                expand = "",
                jump_next = "<Tab>",
                jump_prev = "<S-Tab>",
                stop = "<C-C>",
            },
        })
        snippets.start_lsp_server()
    end,
    dependencies = { { "rafamadriz/friendly-snippets" } },
}
