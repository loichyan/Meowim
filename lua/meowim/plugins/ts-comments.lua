---@type MeoSpec
return {
    "folke/ts-comments.nvim",
    lazy = true,
    config = function() require("ts-comments").setup() end,
}
