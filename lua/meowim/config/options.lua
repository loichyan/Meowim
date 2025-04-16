local g, o = vim.g, vim.o

g.mapleader = " "
g.localleader = "\\"

o.clipboard = "unnamed" -- Use tmux's clipboard
o.relativenumber = true -- Show relative numbers
o.cmdheight = 0 -- Hide cmdline
o.laststatus = 3 -- Show global statusline
o.expandtab = true
o.tabstop = 4
