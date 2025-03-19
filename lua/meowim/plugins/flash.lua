---@type MeoSpec
return {
    "folke/flash.nvim",
    lazy = true,
    config = function()
        ---@diagnostic disable:missing-fields
        require("flash").setup({
            modes = {
                char = {
                    enabled = false,
                    autohide = true,
                    jump_labels = true,
                    multi_line = false,
                    jump = { autojump = true },
                },
                search = {
                    enabled = true,
                    highlight = { backdrop = true },
                    search = { wrap = false },
                },
                treesitter = {
                    highlight = { backdrop = true },
                    label = { style = "overlay" },
                },
            },
            prompt = { enabled = false },
        })

        Meow.keyset({
            {
                "s",
                function() require("flash").jump({ search = { forward = true, wrap = false } }) end,
                mode = { "n", "o", "x" },
                desc = "Flash forward",
            },
            {
                "S",
                function() require("flash").jump({ search = { forward = false, wrap = false } }) end,
                mode = { "n", "o", "x" },
                desc = "Flash backward",
            },
            {
                "O",
                function() require("flash").treesitter() end,
                mode = { "o", "x" },
                desc = "Flash treesitter",
            },
            {
                "<C-S>",
                function() require("flash").toggle() end,
                mode = { "c" },
                desc = "Toggle Flash search",
            },
        })
    end,
}
