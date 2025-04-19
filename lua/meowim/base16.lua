---@class MeoBase16Options
---The name to identify this colorscheme.
---@field name string
---Base16 palette.
---@field palette table<string,string>
---Additional options used to set up mini.base16.
---@field options? table
---Whether to enable transparent background. This only works when the default
---customization function is called.
---@field transparent? boolean
---The path of the runtime file used to determine whether to update the
---colorscheme cache. No cache will be generated if not specified. The default
---is set to `/colors/<name>.lua`.
---@field cache_watch_path string?
---Make customizations on the colors before they are applied.
---@field custom_colors? fun(opts:MeoBase16Options,colors:table):table

local Base16 = {}

---The default options used to set up mini.base16.
---@type table
Base16.defaults = {
    use_cterm = false,
    -- stylua: ignore
    plugins = {
        default = false,
        ["echasnovski/mini.nvim"] = true,
        ["ggandor/leap.nvim"]     = true,
        ["hrsh7th/nvim-cmp"]      = true,
        ["ibhagwan/fzf-lua"]      = true,
    },
}

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
    require("mini.base16").setup(
        vim.tbl_extend("force", Base16.defaults, opts.options or {}, { palette = opts.palette })
    )
    local colors = require("mini.colors").get_colorscheme()
    colors = (opts.custom_colors or Base16.default_colors_customization)(opts, colors)
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

---@param opts MeoBase16Options
---@param colors table
---@return table
function Base16.default_colors_customization(opts, colors)
    ---@return vim.api.keyset.highlight
    local gethl = function(name) return colors.groups[name] end

    ---@param hl vim.api.keyset.highlight
    local defhl = function(name, hl) colors.groups[name] = hl end

    ---@param overrides vim.api.keyset.highlight
    local sethl = function(name, overrides)
        local hl = gethl(name)
        for k, v in pairs(overrides) do
            hl[k] = v
        end
    end

    local rmbg = function(name) colors.groups[name].bg = nil end
    local palette = opts.palette

    if opts.transparent then
        colors = colors:add_transparency()
    end

    -- Reuse highlights of nvim-cmp for blink.cmp.
    for k, _ in pairs(vim.lsp.protocol.CompletionItemKind) do
        if type(k) == "string" then
            defhl("BlinkCmpKind" .. k, { link = "CmpItemKind" .. k })
        end
    end

    -- Reuse highlights of leap.nvim for flash.nvim.
    defhl("FlashBackdrop", { link = "LeapBackdrop" })
    defhl("FlashCurrent", { link = "LeapLabelSelected" })
    defhl("FlashLabel", { link = "LeapLabel" })
    defhl("FlashMatch", { link = "LeapMatch" })

    -- Use undercurl for diagnostics
    for _, kind in ipairs({ "Ok", "Hint", "Info", "Warn", "Error" }) do
        sethl("DiagnosticUnderline" .. kind, { underline = false, undercurl = true })
    end

    -- Prefer yellow color for diagnostics.
    sethl("DiagnosticWarn", { fg = palette.base0A })
    sethl("DiagnosticFloatingWarn", { fg = palette.base0A })
    sethl("DiagnosticUnderlineWarn", { sp = palette.base0A })

    -- Prefer white indentlines and Delimiters.
    gethl("MiniIndentscopeSymbol").fg = palette.base04
    defhl("MiniIndentscopeSymbolOff", { link = "MiniIndentscopeSymbol" })
    gethl("Delimiter").fg = palette.base04

    -- Use the default highlights for `return`s.
    defhl("@keyword.return", { link = "Keyword" })

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

    -- TODO: report inconsistent higroups to mini.base16

    -- Add bg for floating titles.
    defhl("MiniNotifyTitle", { link = "MiniPickHeader" })

    -- Make tabline transparent.
    rmbg("TabLineFill")

    -- Add bg for fzf pickers.
    defhl("FzfLuaBorder", { link = "MiniPickBorder" })
    defhl("FzfLuaNormal", { link = "MiniPickNormal" })
    defhl("FzfLuaTitle", { link = "MiniPickHeader" })

    return colors
end

return Base16
