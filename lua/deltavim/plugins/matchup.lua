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
  opts = {
    matchparen_offscreen = {},
  },
  config = function(_, opts)
    local ok, cmp = pcall(require, "cmp")
    if ok then
      -- https://github.com/hrsh7th/nvim-cmp/issues/1940#issuecomment-2241068952
      cmp.event:on("menu_opened", function() vim.b.matchup_matchparen_enabled = false end)
      cmp.event:on("menu_closed", function() vim.b.matchup_matchparen_enabled = true end)
    end
    require("match-up").setup(opts)

    -- Previously, if an 'open' or 'close' that would have been highlighted was
    -- on a line positioned outside the current window, the match would be
    -- shown in the statusline. As this overrides the statusline, it is
    -- disabled by default.
    vim.g.matchup_matchparen_offscreen = opts.matchparen_offscreen
  end,
}
