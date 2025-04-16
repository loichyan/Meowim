---@type MeoSpec
return {
    "ibhagwan/fzf-lua",
    event = "VeryLazy",
    init = function()
        -- Replace vim.ui.select with the fzf picker.
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.ui.select = function(...)
            local fzf_select = require("fzf-lua.providers.ui_select").ui_select
            vim.ui.select = fzf_select
            fzf_select(...)
        end
    end,
    config = function()
        local fzf = require("fzf-lua")
        fzf.setup({
            "ivy",
            keymap = {
                builtin = {
                    true,
                    ["<C-D>"] = "preview-page-down",
                    ["<C-U>"] = "preview-page-up",
                },
                fzf = {
                    true,
                    ["ctrl-d"] = "preview-page-down",
                    ["ctrl-u"] = "preview-page-up",
                    ["ctrl-q"] = "select-all+accept",
                },
            },
        })
    end,
}
