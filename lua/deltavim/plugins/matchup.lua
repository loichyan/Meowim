---@type LazyPluginSpec
return {
  "andymass/vim-matchup",
  lazy = true,
  event = "VeryLazy",
  specs = {
    "nvim-treesitter",
    opts = {
      matchup = { enable = true },
    },
  },
}
