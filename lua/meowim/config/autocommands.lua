local trivial_files = {
    ["checkhealth"] = true,
    ["fzf"] = true,
    ["git"] = true,
    ["help"] = true,
    ["lspinfo"] = true,
    ["man"] = true,
    ["nofile"] = true,
    ["notify"] = true,
    ["qf"] = true,
    ["query"] = true,
    ["quickfix"] = true,
    ["startuptime"] = true,
    ["vim"] = true,
}
local rulers = {
    ["*"] = 80,
    ["git"] = 72,
    ["gitcommit"] = 72,
    ["markdown"] = 100,
}

local au = vim.api.nvim_create_autocmd
au("FileType", {
    desc = "Tweak trivial files",
    pattern = vim.tbl_keys(trivial_files),
    callback = function(ev)
        vim.b.miniindentscope_disable = true
        vim.bo.buflisted = false
        vim.keymap.set(
            "n",
            "q",
            "<Cmd>close<CR>",
            { desc = "Close current window", buffer = ev.buf }
        )
    end,
})
au("FileType", {
    desc = "Configure rulers",
    callback = function()
        local ft = vim.bo.filetype
        if trivial_files[ft] then
            return
        end
        local width = rulers[ft] or rulers["*"]
        vim.opt_local.textwidth = width
        vim.opt_local.colorcolumn = { width }
    end,
})
