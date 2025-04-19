-- Scheme: Catppuccin Frappe/Latte
-- Author: https://github.com/catppuccin
local background, palette = vim.g.background or "dark", nil
if background == "dark" then
    palette = {
        base00 = "#303446",
        base01 = "#292c3c",
        base02 = "#414559",
        base03 = "#51576d",
        base04 = "#626880",
        base05 = "#c6d0f5",
        base06 = "#f2d5cf",
        base07 = "#babbf1",
        base08 = "#e78284",
        base09 = "#ef9f76",
        base0A = "#e5c890",
        base0B = "#a6d189",
        base0C = "#81c8be",
        base0D = "#8caaee",
        base0E = "#ca9ee6",
        base0F = "#eebebe",
    }
else
    palette = {
        base00 = "#eff1f5",
        base01 = "#e6e9ef",
        base02 = "#ccd0da",
        base03 = "#bcc0cc",
        base04 = "#acb0be",
        base05 = "#4c4f69",
        base06 = "#dc8a78",
        base07 = "#7287fd",
        base08 = "#d20f39",
        base09 = "#fe640b",
        base0A = "#df8e1d",
        base0B = "#40a02b",
        base0C = "#179299",
        base0D = "#1e66f5",
        base0E = "#8839ef",
        base0F = "#dd7878",
    }
end
require("meowim.base16").setup({
    name = "catppuccin-" .. background,
    cache_watch_path = "/colors/catppuccin.lua",
    palette = palette,
})
