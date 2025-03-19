---@type MeoSpec
return {
    "catppuccin",
    source = "catppuccin/nvim",
    disabled = function() return vim.g.colorscheme ~= "catppuccin" end,
    lazy = false,
    config = function()
        require("catppuccin").setup({
            flavour = "mocha",
            transparent_background = true,
            default_integrations = false,
            term_colors = true,
            integrations = {
                blink_cmp = true,
                fzf = true,
                markdown = true,
                mini = true,
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = { "italic" },
                        hints = { "italic" },
                        warnings = { "italic" },
                        information = { "italic" },
                        ok = { "italic" },
                    },
                    underlines = {
                        errors = { "undercurl" },
                        hints = { "undercurl" },
                        warnings = { "undercurl" },
                        information = { "undercurl" },
                        ok = { "undercurl" },
                    },
                    inlay_hints = {
                        background = false,
                    },
                },
                semantic_tokens = true,
                snacks = true,
                treesitter = true,
            },
            custom_highlights = function(c)
                return {
                    FlashBackdrop = { fg = c.overlay0 },
                    FlashCurrent = { fg = c.green, bold = true },
                    FlashLabel = { fg = c.red, bold = true },
                    FlashMatch = { fg = c.lavender, bold = true },
                    LspInlayHint = { fg = c.surface1, italic = true },
                }
            end,
        } --[[@type CatppuccinOptions]])
        vim.cmd("colorscheme catppuccin")
    end,
}
