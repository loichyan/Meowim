---@type LazyPluginSpec
return {
  "andymass/vim-matchup",
  lazy = true,
  event = "User AstroFile",
  specs = {
    "nvim-treesitter",
    opts = {
      matchup = { enable = true },
    },
  },
}
