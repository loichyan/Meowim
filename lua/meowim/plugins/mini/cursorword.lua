---@type MeoSpec
return {
    "mini.cursorword",
    event = "VeryLazy",
    config = function() require("mini.cursorword").setup({ delay = 300 }) end,
}
