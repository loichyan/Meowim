---@type MeoSpec
return {
    "mini.files",
    event = "VeryLazy",
    config = function()
        require("mini.files").setup({
            options = { use_as_default_explorer = true },
        })
        Meow.keyset({
            {
                "<Leader>e",
                function()
                    local path = vim.api.nvim_buf_get_name(0)
                    require("mini.files").open(vim.loop.fs_stat(path) and path or nil)
                end,
                desc = "Open file explorer",
            },
            {
                "<Leader>E",
                function() require("mini.files").open() end,
                desc = "Open file explorer at root",
            },
        })
    end,
}
