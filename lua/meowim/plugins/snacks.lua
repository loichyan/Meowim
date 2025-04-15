---@type MeoSpec
return {
    "folke/snacks.nvim",
    lazy = true,
    config = function()
        require("snacks").setup({
            bigfile = { enabled = true },
            quickfile = { enabled = true },
            input = { enabled = true },
        })
        vim.api.nvim_create_autocmd("User", {
            pattern = "MiniFilesActionRename",
            callback = function(event)
                require("snacks.rename").on_rename_file(event.data.from, event.data.to)
            end,
        })
    end,
}
