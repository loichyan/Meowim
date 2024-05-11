---@type LazyPluginSpec
return {
  "AstroNvim/astrotheme",
  lazy = true,
  ---@type AstroThemeOpts
  opts = {
    plugins = { ["dashboard-nvim"] = true },
  },
}
