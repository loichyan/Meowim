---@type LazyPluginSpec
return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",

  dependencies = {
    { "hrsh7th/cmp-buffer", lazy = true },
    { "hrsh7th/cmp-path", lazy = true },
    {
      "hrsh7th/cmp-nvim-lsp",
      lazy = true,
      dependencies = {
        "AstroNvim/astrolsp",
        optional = true,
        opts = {
          capabilities = {
            textDocument = {
              completion = {
                completionItem = {
                  documentationFormat = { "markdown", "plaintext" },
                  snippetSupport = true,
                  preselectSupport = true,
                  insertReplaceSupport = true,
                  labelDetailsSupport = true,
                  deprecatedSupport = true,
                  commitCharactersSupport = true,
                  tagSupport = { valueSet = { 1 } },
                  resolveSupport = {
                    properties = { "documentation", "detail", "additionalTextEdits" },
                  },
                },
              },
            },
          },
        },
      },
    },
  },

  opts = function()
    local cmp, astro = require "cmp", require "astrocore"

    local sources = {}
    for plug, source in pairs {
      ["cmp-buffer"] = { name = "buffer", priority = 500, group_index = 2 },
      ["cmp-nvim-lsp"] = { name = "nvim_lsp", priority = 1000 },
      ["cmp-path"] = { name = "path", priority = 250 },
      ["cmp_luasnip"] = { name = "luasnip", priority = 750 },
    } do
      if astro.is_available(plug) then table.insert(sources, source) end
    end

    -- snippet integration
    local snip_expand, snip_next, snip_prev
    if astro.is_available "LuaSnip" then -- use LuaSnip as the backend
      snip_expand = function(args) return require("luasnip").lsp_expand(args.body) end
      snip_next = function(fallback)
        local luasnip = require "luasnip"
        if luasnip.locally_jumpable(1) then
          luasnip.jump(1)
        else
          fallback()
        end
      end
      snip_prev = function(fallback)
        local luasnip = require "luasnip"
        if luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end
    else -- or fallback to the NeoVim builtin one
      snip_expand = function(args) return vim.snippet and vim.snippet.expand(args.body) end
      snip_next = function(fallback)
        if vim.snippet and vim.snippet.active { direction = 1 } then
          vim.schedule(function() vim.snippet.jump(1) end)
        else
          fallback()
        end
      end
      snip_prev = function(fallback)
        if vim.snippet and vim.snippet.active { direction = -1 } then
          vim.schedule(function() vim.snippet.jump(-1) end)
        else
          fallback()
        end
      end
    end

    local mapping = {
      ["<C-y>"] = cmp.config.disable,

      ["<Up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
      ["<Down>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
      ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
      ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },

      ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
      ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),

      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ["<CR>"] = cmp.mapping.confirm { select = false },
      ["<C-e>"] = cmp.mapping { i = cmp.mapping.abort(), c = cmp.mapping.close() },

      ["<Tab>"] = cmp.mapping(snip_next, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(snip_prev, { "i", "s" }),
    }

    local icon = require("astroui").get_icon
    return {
      enabled = function()
        if vim.bo[0].buftype == "prompt" then return false end
        ---@diagnostic disable-next-line: undefined-field
        return vim.F.if_nil(vim.b.cmp_enabled, astro.config.features.cmp)
      end,
      snippet = { expand = snip_expand },
      formatting = {
        fields = { "kind", "abbr" },
        format = function(_, item)
          item.kind = " " .. icon(item.kind) .. " "
          return item
        end,
      },
      confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      },
      completion = {
        completeopt = "menu,menuone",
      },
      window = {
        completion = {
          col_offset = -2,
          side_padding = 0,
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        },
        documentation = {
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        },
      },
      mapping = mapping,
      sources = sources,
    }
  end,

  config = function(_, opts)
    for _, source in ipairs(opts.sources or {}) do
      if not source.group_index then source.group_index = 1 end
    end
    require("cmp").setup(opts)
  end,
}
