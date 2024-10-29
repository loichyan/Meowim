---@module "luasnip"

---@type LazyPluginSpec
local Spec = {
  "l3mon4d3/luasnip",
  lazy = true,
  dependencies = { { "rafamadriz/friendly-snippets", lazy = true } },
  specs = {
    {
      "nvim-cmp",
      dependencies = { { "saadparwaiz1/cmp_luasnip", lazy = true } },
      opts = function(_, opts)
        local luasnip, cmp = require "luasnip", require "cmp"

        if not opts.sources then opts.sources = {} end
        table.insert(opts.sources, { name = "luasnip", priority = 750 })

        if not opts.snippet then opts.snippet = {} end
        opts.snippet.expand = function(args) luasnip.lsp_expand(args.body) end

        if not opts.mappings then opts.mappings = {} end
        opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
          if luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s" })
        opts.mapping["<S-Tab>"] = cmp.mapping(function(fallback)
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" })
      end,
    },
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

return Spec
