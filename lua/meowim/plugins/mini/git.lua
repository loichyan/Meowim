---@type MeoSpec
return {
    "mini.git",
    event = "VeryLazy",
    config = function() require("mini.git").setup() end,
}
