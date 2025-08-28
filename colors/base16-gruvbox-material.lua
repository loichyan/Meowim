local palette
if vim.o.background ~= "light" then
  -- Scheme: Gruvbox Material Dark
  -- Author: Sainnhe Park (https://github.com/sainnhe)
  palette = {
    base00 = "#1b1b1b",
    base01 = "#282828",
    base02 = "#3c3836",
    base03 = "#504945",
    base04 = "#665c54",

    base05 = "#d4be98",
    base06 = "#ddc7a1",
    base07 = "#e6d5ae",

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
  -- Scheme: Gruvbox Material Light
  -- Author: Sainnhe Park (https://github.com/sainnhe)
  palette = {
    base00 = "#eee0b7",
    base01 = "#e6d5ae",
    base02 = "#d5c4a1",
    base03 = "#a89984",
    base04 = "#928374",

    base05 = "#3c3836",
    base06 = "#282828",
    base07 = "#1b1b1b",

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
  name = "base16-gruvbox",
  variant = vim.o.background,
  bright = 0.05,
  palette = palette,
})
