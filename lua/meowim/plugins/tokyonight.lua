---@type MeoSpec
return {
    "folke/tokyonight.nvim",
    disabled = function() return vim.g.colorscheme ~= "tokyonight" end,
    lazy = false,
    priority = 5,
    config = function()
        require("tokyonight").setup({
            style = "moon",
            transparent = true,
            plugins = { all = true },
        })
        vim.cmd("colorscheme tokyonight")
    end,
}
