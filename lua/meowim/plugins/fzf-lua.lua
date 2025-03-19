---@type MeoSpec
return {
    "ibhagwan/fzf-lua",
    lazy = true,
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
        fzf.register_ui_select()
    end,
}
