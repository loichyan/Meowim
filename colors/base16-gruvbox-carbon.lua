local palette

if vim.o.background ~= "light" then
  -- Scheme: Gruvbox Carbon Dark
  -- Author: Sainnhe Park (https://github.com/sainnhe), Loi Chyan (https://github.com/loichyan)
  palette = {
    base00 = "#0e0e0e",
    base01 = "#1f1f1f",
    base02 = "#35312f",
    base03 = "#4b4440",
    base04 = "#645a52",

    base05 = "#ccb690",
    base06 = "#d7c19c",
    base07 = "#e3d2ab",

    base08 = "#ea6962",
    base09 = "#e78a4e",
    base0A = "#d8a657",
    base0B = "#a9b665",
    base0C = "#89b482",
    base0D = "#7daea3",
    base0E = "#d3869b",
    base0F = "#a89984",
  }
else
  -- Scheme: Gruvbox Carbon Light
  -- Author: Sainnhe Park (https://github.com/sainnhe), Loi Chyan (https://github.com/loichyan)
  palette = {
    base00 = "#fff5d5",
    base01 = "#fcebc3",
    base02 = "#e7d6b2",
    base03 = "#b6a791",
    base04 = "#9e8f7f",

    base05 = "#433f3d",
    base06 = "#2d2d2d",
    base07 = "#1d1d1d",

    base08 = "#9d0006",
    base09 = "#af3a03",
    base0A = "#a26700",
    base0B = "#79740e",
    base0C = "#427b58",
    base0D = "#076678",
    base0E = "#8f3f71",
    base0F = "#7c6f64",
  }
end
require("meowim.base16").setup({
  name = "base16-gruvbox-carbon",
  variant = vim.o.background,
  bright = 0.05,
  palette = palette,
})
