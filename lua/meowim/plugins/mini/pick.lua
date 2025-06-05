---Lists notifications from mini.notify.
-- TODO: contribute to mini.extra
local pick_notify = function()
    local notify = require("mini.notify")
    local format = (notify.config or vim.b.mininotify_config or {}).format or notify.default_format

    local items = vim.tbl_filter(function(item)
        if item.data.source ~= "vim.notify" then
            return false
        end
        item.text = vim.split(format(item), "\n")[1]
        return true
    end, notify.get_all())
    -- Make notifications ordered from oldest to newest.
    table.sort(items, function(a, b) return a.ts_update < b.ts_update end)

    MiniPick.start({
        source = {
            name = "Notifications",
            preview = function(buf_id, item)
                vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, vim.split(item.msg, "\n"))
            end,
            items = items,
        },
    })
end

-- TODO: implement messages picker
-- local pick_messages = function()end

local open_quickfix = function()
    MiniPick.default_choose_marked(MiniPick.get_picker_matches().all, { list_type = "quickfix" })
    return true
end

local config = function()
    local pick = require("mini.pick")
    pick.setup({
            -- stylua: ignore
            mappings = {
              choose        = "<CR>",
              choose_marked = "<M-CR>",
              refine        = "<C-Space>",
              refine_marked = "<M-Space>",

              scroll_left   = "<C-h>",
              scroll_right  = "<C-l>",
              scroll_down   = "<C-f>",
              scroll_up     = "<C-b>",

              stop          = "<Esc>",

              open_quickfix = { char = "<C-q>", func = open_quickfix },
            },
    })
    -- TODO: use config.source.preview
    local preview = pick.default_preview
    ---@diagnostic disable-next-line: duplicate-set-field
    pick.default_preview = function(b, i, o)
        return preview(b, i, vim.tbl_extend("force", { line_position = "center" }, o or {}))
    end
    pick.registry.notify = pick_notify

    Meow.load("mini.extra") -- Register extra pickers.
end

---@type MeoSpec
return {
    "mini.pick",
    event = "VeryLazy",
    init = function()
        -- Replace vim.ui.select with mini's picker.
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.ui.select = function(...) require("mini.pick").ui_select(...) end
    end,
    config = config,
}
