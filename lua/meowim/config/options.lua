-- Options that must be set before loading plugins.

local g, o = vim.g, vim.o

g.mapleader = " "
g.localleader = "\\"

o.clipboard = "unnamed"
o.expandtab = true
o.tabstop = 4
o.shiftwidth = 4

o.cmdheight = 0 -- Hide cmdline
o.laststatus = 3 -- Show global statusline
o.conceallevel = 2 -- Improve rendering for Markdown
o.relativenumber = true -- Show relative numbers
