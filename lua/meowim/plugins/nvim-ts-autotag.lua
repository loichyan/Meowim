---@type MeoSpec
return {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter" },
    config = function() require("nvim-ts-autotag").setup() end,
}
