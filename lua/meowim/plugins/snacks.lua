---@type MeoSpec
return {
    "folke/snacks.nvim",
    lazy = false,
    priority = 10,
    config = function()
        require("snacks").setup({
            bigfile = { enabled = true },
            quickfile = { enabled = true },
            input = { enabled = true },
        })
    end,
}
