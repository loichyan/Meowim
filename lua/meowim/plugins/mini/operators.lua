---@type MeoSpec
return {
    "mini.operators",
    event = "VeryLazy",
    config = function()
        -- stylua: ignore
        require("mini.operators").setup({
            evaluate = { prefix = "g=" },
            exchange = { prefix = "gx" },
            multiply = { prefix = "gm" },
            replace  = { prefix = "gr" },
            sort     = { prefix = "gs" },
        })

        -- Use 'gX' instead of Neovim's bultin 'gx' to open URIs.
        Meow.keyset({
            {
                "gX",
                function() vim.ui.open(vim.fn.expand("<cfile>")) end,
                desc = "Open URI under cursor",
            },
            {
                "gX",
                function()
                    local lines = vim.fn.getregion(
                        vim.fn.getpos("."),
                        vim.fn.getpos("v"),
                        { type = vim.fn.mode() }
                    )
                    vim.ui.open(table.concat(vim.tbl_map(vim.trim, lines)))
                end,
                mode = "x",
                desc = "Open selected URI",
            },
        })
    end,
}
