---@type MeoSpec
return {
    "windwp/nvim-ts-autotag",
    lazy = true,
    dependencies = { "nvim-treesitter" },
    config = function() require("nvim-ts-autotag").setup() end,
}
