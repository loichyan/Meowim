---@type MeoSpec
return {
    "stevearc/quicker.nvim",
    lazy = true,
    config = function() require("quicker").setup() end,
}
