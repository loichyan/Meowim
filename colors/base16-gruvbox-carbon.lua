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
    base00 = "#fff4d3",
    base01 = "#f4e3bc",
    base02 = "#ddcca9",
    base03 = "#ad9e89",

    base04 = "#958677",
    base05 = "#433f3d",
    base06 = "#2d2d2d",
    base07 = "#1d1d1d",

    base08 = "#9d0006",
    base09 = "#af3a03",
    base0A = "#b57614",
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
