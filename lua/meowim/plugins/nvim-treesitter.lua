---@type MeoSpec
return {
    "nvim-treesitter/nvim-treesitter",
    build = function() vim.cmd("TSUpdate") end,
    event = "VeryLazy",
    config = function()
        ---@diagnostic disable-next-line:missing-fields
        require("nvim-treesitter.configs").setup({
            sync_install = false,
            ensure_installed = {
                "bash",
                "c",
                "diff",
                "html",
                "lua",
                "luadoc",
                "markdown",
                "markdown_inline",
                "query",
                "vim",
                "vimdoc",
            },
            auto_install = true,
            highlight = { enable = true, additional_vim_regex_highlighting = false },
            incremental_selection = { enable = false },
            indent = { enable = false },
            textobjects = { enable = false },
        })
    end,
}
