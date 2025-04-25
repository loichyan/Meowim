---@type MeoSpec
return {
    "mini.pick",
    event = "VeryLazy",
    init = function()
        -- Replace vim.ui.select with mini's picker.
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.ui.select = function(...) require("mini.pick").ui_select(...) end
    end,
    config = function()
        local open_quickfix = function()
            MiniPick.default_choose_marked(
                MiniPick.get_picker_matches().all,
                { list_type = "quickfix" }
            )
            return true
        end

        local pick = require("mini.pick")
        pick.setup({
            -- stylua: ignore
            mappings = {
              choose        = "<CR>",
              choose_marked = "<M-CR>",
              refine        = "<C-Space>",
              refine_marked = "<M-Space>",

              scroll_left   = "<C-h>",
              scroll_down   = "<C-j>",
              scroll_up     = "<C-k>",
              scroll_right  = "<C-l>",

              stop          = "<Esc>",

              open_quickfix = { char = "<C-q>", func = open_quickfix },
            },
        })
        local preview = pick.default_preview
        ---@diagnostic disable-next-line: duplicate-set-field
        pick.default_preview = function(b, i, o)
            return preview(b, i, vim.tbl_extend("force", { line_position = "center" }, o or {}))
        end

        Meow.load("mini.extra") -- Register extra pickers.
    end,
}
