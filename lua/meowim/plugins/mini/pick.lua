local get_config = function() return vim.b.minipick_config or MiniPick.config end
local show_with_icons = function(bufnr, items, query, opts)
    return MiniPick.default_show(
        bufnr,
        items,
        query,
        vim.tbl_extend("force", { show_icons = true }, opts or {})
    )
end
local center_preview = function(bufnr, items, opts)
    return MiniPick.default_preview(
        bufnr,
        items,
        vim.tbl_extend("force", { line_position = "center" }, opts or {})
    )
end

---Lists files with a sensible picker.
---@param opts? {hidden:boolean}
local pick_smart_files = function(opts)
    opts = vim.tbl_extend("force", { hidden = false }, opts or {})
    local cwd = vim.fn.getcwd()
    local command
    if opts.hidden then
        command = { "rg", "--files", "--no-follow", "--color=never", "--no-ignore" }
        -- MiniExtra.pickers.git_files(local_opts, opts)
    elseif require("meowim.utils").get_git_repo(cwd) == cwd then
        -- stylua: ignore
        command = { "git", "ls-files", "--exclude-standard", "--cached", "--modified", "--others", "--deduplicate" }
    else
        command = { "rg", "--files", "--no-follow", "--color=never" }
    end

    MiniPick.builtin.cli({ command = command }, {
        source = {
            name = "Files",
            cwd = cwd,
            show = (get_config().source or {}).show or show_with_icons,
        },
    })
end

---Lists all todo comments of the specified keywords.
---@param opts? {scope:"current"|"all",keywords:string[]}
local pick_todo = function(opts)
    opts = vim.tbl_extend("force", { keywords = { "TODO", "FIXME" } }, opts or {})
    require("mini.pick").builtin.grep({
        pattern = "\\b(" .. table.concat(opts.keywords, "|") .. ")(\\(.*\\))?:\\s+.+",
        globs = opts.scope == "current" and { vim.fn.expand("%") } or nil,
    }, {
        source = { name = table.concat(opts.keywords, "|") },
    })
end

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
        source = {
            preview = center_preview,
        },
    })

    -- Register extra pickers.
    Meow.load("mini.extra")
    pick.registry.smart_files = pick_smart_files
    pick.registry.todo = pick_todo
    pick.registry.notify = pick_notify
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
