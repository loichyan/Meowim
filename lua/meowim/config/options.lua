-- Options that must be set before loading plugins.

local g, o, opt = vim.g, vim.o, vim.opt

g.mapleader = " "
g.localleader = "\\"

o.clipboard = "unnamed"
o.expandtab = true
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = 4

o.cmdheight = 0 -- Hide cmdline
o.showcmdloc = "statusline" -- Display command messages in statusline
o.laststatus = 3 -- Show global statusline
o.conceallevel = 2 -- Improve rendering for Markdown
o.relativenumber = true -- Show relative numbers

opt.diffopt:append("algorithm:histogram", "inline:word") -- improve diff mode
