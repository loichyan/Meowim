vim.api.nvim_create_autocmd("FileType", {
    desc = "Tweak trivial files",
    pattern = {
        "checkhealth",
        "fzf",
        "git",
        "help",
        "lspinfo",
        "man",
        "nofile",
        "notify",
        "qf",
        "query",
        "quickfix",
        "startuptime",
        "vim",
    },
    callback = function(args)
        vim.b.miniindentscope_disable = true
        vim.bo.buflisted = false
        vim.keymap.set(
            "n",
            "q",
            "<Cmd>close<CR>",
            { desc = "Close current window", buffer = args.buf }
        )
    end,
})
