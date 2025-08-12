-- Other configurations that may slow down the startup.

-- Force to use JSONC instead of bare JSON.
vim.filetype.add({
  extension = { json = "jsonc" },
})

-- Enable virtual text
vim.diagnostic.config({ virtual_text = true })

-- Register some useful commands

---Pipes command output to a scratch buffer.
vim.api.nvim_create_user_command("Cat", function(ctx)
  local output = vim.api.nvim_exec2(ctx.args, { output = true }).output
  local lines = vim.split(output, "\n", { plain = true })
  vim.cmd(ctx.mods .. " new")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.bo.buflisted = false
  vim.bo.modified = false
  vim.bo.buftype = "nofile"
  vim.bo.filetype = "nofile"
end, { nargs = "+", complete = "command" })
