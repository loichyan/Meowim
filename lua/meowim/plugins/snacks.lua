---@type MeoSpec
return {
    "folke/snacks.nvim",
    event = "VeryLazy",
    lazy = false,
    priority = 90,
    config = function()
        require("snacks").setup({
            quickfile = { enabled = true },
            input = { enabled = true },
        })
        vim.api.nvim_create_autocmd("User", {
            pattern = "MiniFilesActionRename",
            callback = function(ev) Snacks.rename.on_rename_file(ev.data.from, ev.data.to) end,
        })
    end,
}
