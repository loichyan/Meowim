local palette
if vim.o.background == "light" then
  -- Scheme: One Light
  -- Author: Daniel Pfeifer (http://github.com/purpleKarrot)
  palette = {
    base00 = "#fafafa",
    base01 = "#f0f0f1",
    base02 = "#e5e5e6",
    base03 = "#a0a1a7",
    base04 = "#696c77",

    base05 = "#383a42",
    base06 = "#202227",
    base07 = "#090a0b",

    base08 = "#ca1243",
    base09 = "#d75f00",
    base0A = "#c18401",
    base0B = "#50a14f",
    base0C = "#0184bc",
    base0D = "#4078f2",
    base0E = "#a626a4",
    base0F = "#986801",
  }
else
  -- Scheme: One Dark
  -- Author: Lalit Magant (http://github.com/tilal6991)
  palette = {
    base00 = "#282c34",
    base01 = "#353b45",
    base02 = "#3e4451",
    base03 = "#545862",
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
end
require("meowim.base16").setup({
  name = "base16-one",
  variant = vim.o.background,
  palette = palette,
})
