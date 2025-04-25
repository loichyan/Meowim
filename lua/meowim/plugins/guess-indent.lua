---@type MeoSpec
return {
    "nmac427/guess-indent.nvim",
    event = "LazyFile",
    config = function() require("guess-indent").setup({ auto_cmd = true }) end,
}
