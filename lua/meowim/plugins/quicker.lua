---@type MeoSpec
return {
    "stevearc/quicker.nvim",
    event = "LazyFile",
    config = function() require("quicker").setup() end,
}
