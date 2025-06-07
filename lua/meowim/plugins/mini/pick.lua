local get_config = function()
    return vim.tbl_deep_extend("force", MiniPick.config, vim.b.minipick_config or {})
end

---Shows preview at center.
local center_preview = function(bufnr, item, opts)
    return MiniPick.default_preview(
        bufnr,
        item,
        vim.tbl_extend("force", { line_position = "center" }, opts or {})
    )
end

---Shows items with icons.
local show_with_icons = function(bufnr, items, query, opts)
    return MiniPick.default_show(
        bufnr,
        items,
        query,
        vim.tbl_extend("force", { show_icons = true }, opts or {})
    )
end

---Lists files with a sensible picker.
---@param local_opts? {hidden:boolean}
local pick_smart_files = function(local_opts, opts)
    local_opts = vim.tbl_extend("force", { hidden = false }, local_opts or {})
    local cwd = vim.fn.getcwd()
    local command
    if local_opts.hidden then
        command = { "rg", "--files", "--no-follow", "--color=never", "--no-ignore" }
        -- MiniExtra.pickers.git_files(local_opts, opts)
    elseif require("meowim.utils").get_git_repo(cwd) == cwd then
        -- stylua: ignore
        command = { "git", "ls-files", "--exclude-standard", "--cached", "--modified", "--others", "--deduplicate" }
    else
        command = { "rg", "--files", "--no-follow", "--color=never" }
    end

    opts = vim.tbl_deep_extend("force", {
        source = {
            name = "Files",
            cwd = cwd,
            show = (get_config().source or {}).show or show_with_icons,
        },
    }, opts or {})
    MiniPick.builtin.cli({ command = command }, opts)
end

---Lists all todo comments of the specified keywords.
---@param opts? {scope:"current"|"all",keywords:string[]}
local pick_todo = function(opts)
    opts = vim.tbl_extend("force", { keywords = { "TODO", "FIXME" } }, opts or {})
    local keywords = table.concat(opts.keywords, "|")
    require("mini.pick").builtin.grep({
        pattern = "\\b(" .. keywords .. ")(\\(.*\\))?:\\s+.+",
        globs = opts.scope == "current" and { vim.fn.expand("%") } or nil,
    }, {
        source = { name = keywords },
    })
end

---Lists notifications from mini.notify.
-- TODO: contribute to mini.extra
---@param local_opts {source:string[]}
local pick_notify = function(local_opts, opts)
    local_opts = vim.tbl_extend("force", { source = { "vim.notify" } }, local_opts or {})

    local notify = require("mini.notify")
    local notify_config = vim.tbl_deep_extend("force", notify.config, vim.b.mininotify_config or {})
    local format = notify_config.format or notify.default_format

    local items = {}
    for _, notif in pairs(notify.get_all()) do
        if vim.tbl_contains(local_opts.source, notif.data.source) then
            table.insert(items, { _orig = notif, text = vim.split(format(notif), "\n")[1] })
        end
    end
    -- Make notifications ordered from oldest to newest.
    table.sort(items, function(a, b) return a._orig.ts_update < b._orig.ts_update end)

    opts = vim.tbl_deep_extend("force", {
        source = {
            name = "Notifications",
            items = items,
            preview = function(buf_id, item)
                vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, vim.split(item._orig.msg, "\n"))
            end,
            choose = function(item)
                vim.schedule(function() vim.print(item._orig) end)
            end,
        },
    }, opts or {})
    MiniPick.start(opts)
end

---Shows all selected items in the quickfix list.
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
