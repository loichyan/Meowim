---@type MeoSpec
return {
    "mini.bufremove",
    event = "VeryLazy",
    config = function() require("mini.bufremove").setup() end,
}
