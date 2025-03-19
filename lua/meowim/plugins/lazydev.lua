---@type MeoSpec
return {
    "folke/lazydev.nvim",
    lazy = true,
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
