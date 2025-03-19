vim.opt.relativenumber = true
vim.diagnostic.config({ virtual_lines = false, virtual_text = true })
if vim.fn.executable("rg") == 1 then
    vim.opt.grepprg = "rg ,--vimgrep"
end
