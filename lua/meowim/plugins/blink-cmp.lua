---@type MeoSpec
return {
    "saghen/blink.cmp",
    event = "VeryLazy",
    config = function()
        require("blink.cmp").setup({
            signature = { enabled = true },
            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 150,
                },
                ghost_text = { enabled = true },
            },
            snippets = { preset = "mini_snippets" },
            fuzzy = {
                implementation = "lua",
                sorts = { "score", "kind", "sort_text" },
            },
            sources = { default = { "path", "lsp", "snippets", "buffer" } },
            keymap = {
                preset = "none",

                ["<C-K>"] = { "show", "show_documentation", "hide_documentation" },
                ["<C-L>"] = { "show_signature", "hide_signature", "fallback" },

                ["<C-E>"] = { "hide", "fallback" },
                ["<C-Y>"] = { "select_and_accept", "fallback" },
                ["<CR>"] = { "select_and_accept", "fallback" },

                ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },

                ["<C-P>"] = { "select_prev", "fallback" },
                ["<C-N>"] = { "select_next", "fallback" },
                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },

                ["<C-U>"] = { "scroll_documentation_up", "fallback" },
                ["<C-D>"] = { "scroll_documentation_down", "fallback" },
            },
            cmdline = {
                enabled = true,
                keymap = {
                    preset = "none",

                    ["<C-K>"] = { "show", "fallback" },
                    ["<C-Y>"] = { "select_and_accept", "fallback" },
                    ["<C-E>"] = { "cancel", "fallback" },

                    ["<Tab>"] = { "show_and_insert", "select_next", "fallback" },
                    ["<S-Tab>"] = { "show_and_insert", "select_prev", "fallback" },

                    ["<C-N>"] = { "select_next", "fallback" },
                    ["<C-P>"] = { "select_prev", "fallback" },
                    ["<Right>"] = { "select_next", "fallback" },
                    ["<Left>"] = { "select_prev", "fallback" },
                },
            },
            term = { enabled = false },
        })
    end,
    dependencies = { "mini.snippets" },
}
