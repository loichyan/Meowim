require("meowim.utils").cached_colorscheme("onedark", function()
    require("mini.base16").setup({
        palette = {
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
        },
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

    ---@return vim.api.keyset.get_hl_info
    local gethl = function(name) return vim.api.nvim_get_hl(0, { name = name, link = false }) end
    ---@param hl vim.api.keyset.highlight
    local sethl = function(name, hl) vim.api.nvim_set_hl(0, name, hl) end

    local removebg = function(name)
        sethl(name, vim.tbl_extend("force", gethl(name), { bg = "NONE", ctermbg = "NONE" }))
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

    -- Improve highlights for window separators, sign columns, and tabline.
    removebg("WinSeparator")
    removebg("LineNr")
    removebg("LineNrAbove")
    removebg("LineNrBelow")
    removebg("CursorLineNr")
    removebg("SignColumn")
    removebg("CursorLineSign")
    removebg("DiagnosticSignError")
    removebg("DiagnosticSignHint")
    removebg("DiagnosticSignInfo")
    removebg("DiagnosticSignOk")
    removebg("DiagnosticSignWarn")
    sethl("MiniTabLineFill", { link = "MiniTabLineVisible" })
end)
