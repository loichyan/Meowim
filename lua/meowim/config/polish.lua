-- Other configurations that may slow down the startup.

-- Force to use JSONC instead of bare JSON.
vim.filetype.add({
  extension = { json = "jsonc" },
})

-- Enable virtual text
vim.diagnostic.config({
  virtual_text = vim.fn.has("nvim-0.12") == 1 and { current_line = false } or true,
  virtual_lines = { current_line = true },
})

-- Register some useful commands

---Pipes command output to a scratch buffer.
vim.api.nvim_create_user_command("Cat", function(ctx)
  local res = vim.api.nvim_exec2(ctx.args, { output = true })

  local mods = ctx.mods or "tab"
  vim.cmd(mods .. " split")
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].filetype = "nofile"

  local lines = vim.split(res.output, "\n", { plain = true })
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_win_set_buf(0, bufnr)
end, { nargs = "+", complete = "command" })
