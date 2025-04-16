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
                -- configured in blink.cmp
                expand = "",
                jump_next = "",
                jump_prev = "",
                stop = "<C-C>",
            },
        })
    end,
    dependencies = { { "rafamadriz/friendly-snippets" } },
}
