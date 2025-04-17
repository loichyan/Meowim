-- TODO: report inconsistent higroups to mini.base16
require("meowim.utils").cached_colorscheme("onedark", function()
    local palette = {
        base00 = "#282c34",
        base01 = "#353b45",
        base02 = "#3e4451",
        base03 = "#5a646e",
        base04 = "#565c64",
        base05 = "#abb2bf",
        base06 = "#b6bdca",
        base07 = "#c8ccd4",
        base08 = "#e06c75",
        base09 = "#d19a66",
        base0A = "#e5c07b",
        base0B = "#98c379",
        base0C = "#56b6c2",
        base0D = "#61afef",
        base0E = "#c678dd",
        base0F = "#be5046",
    }
    require("mini.base16").setup({
        palette = palette,
        use_cterm = false,
        -- stylua: ignore
        plugins = {
            default = false,
            ["echasnovski/mini.nvim"] = true,
            ["ggandor/leap.nvim"]     = true,
            ["hrsh7th/nvim-cmp"]      = true,
            ["ibhagwan/fzf-lua"]      = true,
        },
    })
    local transparent = true
    local colors = require("mini.colors").get_colorscheme()

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

    return colors:apply()
end)
