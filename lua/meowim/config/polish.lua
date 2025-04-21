-- Other configurations that may slow down the startup.

-- For to use JSONC instead of bare JSON.
vim.filetype.add({
    extension = { json = "jsonc" },
})

-- Other configurations
vim.diagnostic.config({
    -- TODO: see <https://github.com/neovim/neovim/pull/33517>
    virtual_text = { current_line = false },
    virtual_lines = { current_line = true },
})
