---@type MeoSpec
return {
    "mini.statusline",
    lazy = false,
    config = function()
        vim.opt.laststatus = 3
        vim.opt.cmdheight = 0
        require("mini.statusline").setup({
            content = {
                inactive = function() end,
            },
        })
    end,
}
