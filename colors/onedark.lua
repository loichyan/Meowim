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
    use_cterm = true,
})

local hl = vim.api.nvim_set_hl
-- Reuse highlights of nvim-cmp for blink.cmp.
for k, _ in pairs(vim.lsp.protocol.CompletionItemKind) do
    if type(k) == "string" then
        hl(0, "BlinkCmpKind" .. k, { link = "CmpItemKind" .. k })
    end
end

-- Reuse highlights of leap.nvim for flash.nvim.
hl(0, "FlashBackdrop", { link = "LeapBackdrop" })
hl(0, "FlashCurrent", { link = "LeapLabelSelected" })
hl(0, "FlashLabel", { link = "LeapLabel" })
hl(0, "FlashMatch", { link = "LeapMatch" })
