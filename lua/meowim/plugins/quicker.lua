---@type MeoSpec
return {
    "stevearc/quicker.nvim",
    event = "VeryLazy",
    config = function() require("quicker").setup() end,
}
