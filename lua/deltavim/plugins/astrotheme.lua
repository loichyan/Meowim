---@module "astrotheme"

---@type LazyPluginSpec
local Spec = {
  "AstroNvim/astrotheme",
  lazy = true,
  ---@type AstroThemeOpts
  opts = { plugins = { ["dashboard-nvim"] = true } },
}

return Spec
