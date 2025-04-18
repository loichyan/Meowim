local g, o = vim.g, vim.o

g.mapleader = " "
g.localleader = "\\"

o.clipboard = "unnamed" -- Use tmux's clipboard
o.relativenumber = true -- Show relative numbers
o.cmdheight = 0 -- Hide cmdline
o.laststatus = 3 -- Show global statusline
o.expandtab = true
o.tabstop = 4
o.shiftwidth = 4

-- Suppress statusline redrawing when typing in cmdline.
local prev_laststatus
vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdlineLeave" }, {
    desc = "Disable statusline in cmdline",
    callback = function(ev)
        if ev.event == "CmdlineLeave" then
            if prev_laststatus then
                vim.o.laststatus = prev_laststatus
            end
            prev_laststatus = nil
        elseif not prev_laststatus then
            prev_laststatus = vim.o.laststatus
            vim.o.laststatus = 0
        end
    end,
})
