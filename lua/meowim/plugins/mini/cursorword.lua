---@type MeoSpec
return {
    "mini.cursorword",
    event = "LazyFile",
    config = function() require("mini.cursorword").setup({ delay = 300 }) end,
}
