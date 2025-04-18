---@class MeoBase16Options
---The name to identify this colorscheme.
---@field name string
---Base16 palette.
---@field palette table<string,string>
---The path of the runtime file used to determine whether to update the
---colorscheme cache. No cache will be generated if not specified. The default
---is set to `/colors/<name>.lua`.
---@field cache_watch_path string?
---Make customizations on the colors before they are applied.
---@field custom_colors? fun(palette:table<string,string>,colors:table):table

local Base16 = {}

---Apply a customized mini.base16 colorscheme.
---@param opts MeoBase16Options|table
function Base16.setup(opts)
    local name = assert(opts.name)
    local input_path = opts.cache_watch_path or ("/colors/" .. name .. ".lua")
    local self_path = "/lua/meowim/base16.lua"

    local cache_dir = vim.fn.stdpath("cache") .. "/base16/"
    local cache_path = cache_dir .. name .. ".lua"
    local cache_ts_path = cache_dir .. name .. "_cache"

    local input_ts = Base16._get_timestamp(input_path)
    local self_ts = Base16._get_timestamp(self_path)

    -- Try to load from cache.
    local _, cache_ts_file = pcall(io.open, cache_ts_path, "r")
    if cache_ts_file then
        local cache_self_ts, cache_input_ts = cache_ts_file:read("*n", "*n")
        -- Cache is hit, load it.
        if cache_self_ts == self_ts and cache_input_ts == input_ts then
            dofile(cache_path)
            return
        end
    end

    -- Otherwise cache is not found or expired, compile the colorscheme.
    -- 1) Setup mini.base16 and apply customizations.
    require("mini.base16").setup(opts)
    local colors = require("mini.colors").get_colorscheme()
    colors = (opts.custom_colors or Base16.default_colors_customization)(opts.palette, colors)
    colors = colors:apply()
    -- 2) Dump the colorscheme.
    colors:write({ compress = true, directory = cache_dir, name = name })
    -- 3) Re-compile the colorscheme to bytecodes.
    local bytes = string.dump(assert(loadfile(cache_path)), true)
    assert(io.open(cache_path, "wb"):write(bytes))
    -- 4) Save timestamps.
    assert(io.open(cache_ts_path, "w"):write(self_ts, "\n", input_ts))
end

---Returns the last modified time of a runtime file.
---@private
---@param path string
function Base16._get_timestamp(path)
    local realpath = vim.api.nvim_get_runtime_file(path, false)[1]
    if not realpath then
        error("cannot find runtime file: " .. path)
    end
    return assert(vim.loop.fs_stat(realpath)).mtime.nsec
end

---@param palette table<string,string>
---@param colors table
---@param transparent? boolean
---@return table
function Base16.default_colors_customization(palette, colors, transparent)
    -- TODO: report inconsistent higroups to mini.base16

    ---@return vim.api.keyset.highlight
    local gethl = function(name) return colors.groups[name] end
    ---@param hl vim.api.keyset.highlight
    local sethl = function(name, hl) colors.groups[name] = hl end
    ---@param overrides vim.api.keyset.highlight|table<string,vim.NIL>
    local rephl = function(name, overrides)
        local hl = gethl(name)
        for k, v in pairs(overrides) do
            if v == vim.NIL then
                hl[k] = nil
            else
                hl[k] = v
            end
        end
    end
    local rmbg = function(name) colors.groups[name].bg = nil end

    if transparent then
        colors = colors:add_transparency()
        gethl("CursorLine").bg = palette.base00
    end

    -- Reuse highlights of nvim-cmp for blink.cmp.
    for k, _ in pairs(vim.lsp.protocol.CompletionItemKind) do
        if type(k) == "string" then
            sethl("BlinkCmpKind" .. k, { link = "CmpItemKind" .. k })
        end
    end

    -- Reuse highlights of leap.nvim for flash.nvim.
    sethl("FlashBackdrop", { link = "LeapBackdrop" })
    sethl("FlashCurrent", { link = "LeapLabelSelected" })
    sethl("FlashLabel", { link = "LeapLabel" })
    sethl("FlashMatch", { link = "LeapMatch" })

    -- Use undercurl for diagnostics
    for _, kind in ipairs({ "Ok", "Hint", "Info", "Warn", "Error" }) do
        rmbg("DiagnosticSign" .. kind)
        rephl("DiagnosticUnderline" .. kind, { underline = false, undercurl = true })
    end

    -- Prefer yellow color for diagnostics.
    rephl("DiagnosticWarn", { fg = palette.base0A })
    rephl("DiagnosticFloatingWarn", { fg = palette.base0A })
    rephl("DiagnosticUnderlineWarn", { sp = palette.base0A })

    -- Make window separators and sign columns transparent.
    rmbg("WinSeparator")
    rmbg("StatusLine")
    rmbg("StatusLineTerm")
    rmbg("StatusLineNC")
    rmbg("StatusLineTermNC")
    rmbg("LineNr")
    rmbg("LineNrAbove")
    rmbg("LineNrBelow")
    rmbg("CursorLineNr")
    rmbg("SignColumn")
    rmbg("CursorLineSign")

    -- Make errors transparent.
    rmbg("Error")
    rmbg("ErrorMsg")

    -- Add bg for floating titles.
    sethl("MiniNotifyTitle", { link = "MiniPickHeader" })

    -- Make tabline transparent.
    rmbg("TabLineFill")

    -- Add bg for fzf pickers.
    sethl("FzfLuaBorder", { link = "MiniPickBorder" })
    sethl("FzfLuaNormal", { link = "MiniPickNormal" })
    sethl("FzfLuaTitle", { link = "MiniPickHeader" })

    -- Prefer white indentlines.
    gethl("MiniIndentscopeSymbol").fg = palette.base05
    gethl("MiniIndentscopeSymbolOff").fg = palette.base04

    return colors
end

return Base16
