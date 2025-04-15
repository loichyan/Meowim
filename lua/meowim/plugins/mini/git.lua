---@type MeoSpec
return {
    "mini.git",
    lazy = true,
    config = function() require("mini.git").setup() end,
}
