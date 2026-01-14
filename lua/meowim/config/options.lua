-- Options that must be set before loading plugins.

local g, o, opt = vim.g, vim.o, vim.opt

g.mapleader = " "
g.localleader = "\\"

o.clipboard = "unnamed"
o.expandtab = true
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = 4

o.cmdheight = 0 -- hide cmdline
o.showcmdloc = "statusline" -- display command messages in statusline
o.laststatus = 3 -- show global statusline
o.showtabline = 2 -- always show tabline
o.conceallevel = 2 -- improve rendering for Markdown
o.relativenumber = true -- show relative numbers

o.jumpoptions = "stack" -- more intuitive jumps
opt.diffopt:append("algorithm:histogram", "inline:word") -- improve diff mode
opt.shortmess:append("A") -- suppress swapfile warnings

o.foldmethod = "expr"
o.foldexpr = "v:lua.Meowim.utils.foldexpr()" -- fold based on LSP or treesitter
o.foldlevel = 99

if vim.fn.has("nvim-0.12") == 1 then
  opt.fillchars:append({
    fold = " ",
    foldclose = "",
    foldinner = " ",
    foldopen = "",
    foldsep = " ",
  })
  o.statuscolumn = "%s%l%C "
  o.foldcolumn = "1"
end
