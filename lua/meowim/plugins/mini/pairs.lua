-- Credit: https://github.com/LazyVim/LazyVim/blob/25abbf546d564dc484cf903804661ba12de45507/lua/lazyvim/util/mini.lua#L97
-- License: Apache-2.0
local open
---@param pair string
---@param neigh_pattern string
local smart_pairs = function(pair, neigh_pattern)
    if vim.fn.getcmdline() ~= "" then
        return open(pair, neigh_pattern)
    end
    local o, c = pair:sub(1, 1), pair:sub(2, 2)
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]

    -- Handle codeblocks in Markdown files
    if o == "`" and vim.bo.filetype == "markdown" and line:sub(1, col):match("^%s*``") then
        return "`\n```" .. vim.api.nvim_replace_termcodes("<Up>", true, true, true)
    end

    -- Skip next if there's already a pair.
    if o == line:sub(col + 1, col + 1) then
        return vim.api.nvim_replace_termcodes("<Right>", true, true, true)
    end

    -- Emit a opening only if unbalanced
    if #line < 500 then
        local _, opened = line:gsub("%" .. o, "")
        if o ~= c then
            local _, closed = line:gsub("%" .. c, "")
            if closed > opened then
                return o
            end
        elseif opened % 2 ~= 0 then
            return o
        end
    end

    return open(pair, neigh_pattern)
end

local config = function()
    local pairs = require("mini.pairs")
    pairs.setup({
        modes = { insert = true, command = false, terminal = false },
        mappings = {
            [">"] = {
                action = "close",
                pair = "<>",
                neigh_pattern = "[^\\].",
                register = { cr = false },
            },
        },
    })

    open = pairs.open
    ---@diagnostic disable-next-line: duplicate-set-field
    pairs.open = smart_pairs
end

---@type MeoSpec
return { "mini.pairs", event = "LazyFile", config = config }
