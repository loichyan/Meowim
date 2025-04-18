---@type MeoSpec
return {
    "folke/snacks.nvim",
    event = "VeryLazy",
    config = function()
        require("snacks").setup({ input = { enabled = true } })
        vim.api.nvim_create_autocmd("User", {
            pattern = "MiniFilesActionRename",
            callback = function(ev) Snacks.rename.on_rename_file(ev.data.from, ev.data.to) end,
        })
    end,
}
