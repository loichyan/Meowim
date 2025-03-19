---@type MeoSpec
return {
    "nmac427/guess-indent.nvim",
    lazy = true,
    config = function()
        require("guess-indent").setup({
            auto_cmd = true,
        })
    end,
}
