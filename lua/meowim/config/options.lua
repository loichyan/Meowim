-- Options that must be set before loading plugins.

local g, o = vim.g, vim.o

g.mapleader = " "
g.localleader = "\\"

o.clipboard = "unnamed" -- Use tmux's clipboard
o.relativenumber = true -- Show relative numbers
o.expandtab = true
o.tabstop = 4
o.shiftwidth = 4
o.conceallevel = 2
