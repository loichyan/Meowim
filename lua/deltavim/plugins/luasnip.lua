---@type LazyPluginSpec
return {
  "L3MON4D3/LuaSnip",
  lazy = true,

  dependencies = {
    { "rafamadriz/friendly-snippets", lazy = true },
    { "saadparwaiz1/cmp_luasnip", lazy = true },
  },

  opts = {
    history = true,
    delete_check_events = "TextChanged",
    region_check_events = "CursorMoved",
    update_events = "TextChanged,TextChangedI",
  },

  config = function(_, opts)
    require("luasnip").config.setup(opts or {})
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_snipmate").lazy_load()
    require("luasnip.loaders.from_lua").lazy_load()
  end,
}
