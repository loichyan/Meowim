---@type MeoSpec
return {
    "folke/lazydev.nvim",
    event = "VeryLazy",
    config = function()
        ---@diagnostic disable-next-line:missing-fields
        require("lazydev").setup({
            library = {
                "meow.nvim",
                "mini.nvim",
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        })
    end,
}
