---@type LazyPluginSpec
return {
  "andymass/vim-matchup",
  lazy = true,
  event = "VeryLazy",
  specs = {
    "nvim-treesitter/nvim-treesitter",
    matchup = {
      enable = true,
    },
  },
}
