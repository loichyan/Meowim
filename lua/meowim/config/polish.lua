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

vim.api.nvim_create_user_command("Cat", function(ctx)
    local output = vim.api.nvim_exec2(ctx.args, { output = true }).output
    local lines = vim.split(output, "\n", { plain = true })
    vim.cmd(ctx.mods .. " new")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.opt_local.buflisted = false
    vim.opt_local.buftype = "nofile"
    vim.opt_local.filetype = "nofile"
    vim.opt_local.modified = false
end, { nargs = "+", complete = "command" })
