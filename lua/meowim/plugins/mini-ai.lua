---@type MeoSpec
return {
    "mini.ai",
    lazy = true,
    config = function()
        local ai = require("mini.ai")
        local ts = ai.gen_spec.treesitter
        require("mini.ai").setup({
            n_lines = 500,
            search_method = "cover_or_next",
            custom_textobjects = {
                c = ts({ a = "@class.outer", i = "@class.inner" }),
                f = ts({ a = "@function.outer", i = "@function.inner" }),
                o = ts({
                    a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                    i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                }),
            },
        })
    end,
    dependencies = {
        {
            "nvim-treesitter/nvim-treesitter-textobjects",
            dependencies = { "nvim-treesitter" },
        },
    },
}
