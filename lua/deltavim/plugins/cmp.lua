---@module "nvim-cmp"

---@type LazyPluginSpec
local Spec = {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",

  dependencies = {
    { "hrsh7th/cmp-buffer", lazy = true },
    { "hrsh7th/cmp-path",   lazy = true },
    { "cmp-nvim-lsp",       optional = true },
  },

  opts = function()
    local cmp, astro = require "cmp", require "astrocore"

    local cmapping = cmp.mapping
    local mapping = {
      ["<C-Y>"] = cmp.config.disable,

      ["<Up>"] = cmapping(
        cmapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
        { "i", "c" }
      ),
      ["<Down>"] = cmapping(
        cmapping.select_next_item { behavior = cmp.SelectBehavior.Select },
        { "i", "c" }
      ),
      ["<C-P>"] = cmapping(
        cmapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
        { "i", "c" }
      ),
      ["<C-N>"] = cmapping(
        cmapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
        { "i", "c" }
      ),

      ["<C-U>"] = cmapping(cmapping.scroll_docs(-4), { "i", "c" }),
      ["<C-D>"] = cmapping(cmapping.scroll_docs(4), { "i", "c" }),

      ["<C-Space>"] = cmapping(cmapping.complete(), { "i", "c" }),
      ["<CR>"] = cmapping(cmapping.confirm { select = false }, { "i", "c" }),
      ["<C-E>"] = cmapping { i = cmapping.abort(), c = cmp.mapping.close() },

      ["<Tab>"] = cmapping(function(fallback)
        if
            vim.api.nvim_get_mode() ~= "c"
            and vim.snippet
            and vim.snippet.active { direction = 1 }
        then
          vim.schedule(function() vim.snippet.jump(1) end)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmapping(function(fallback)
        if
            vim.api.nvim_get_mode() ~= "c"
            and vim.snippet
            and vim.snippet.active { direction = -1 }
        then
          vim.schedule(function() vim.snippet.jump(-1) end)
        else
          fallback()
        end
      end, { "i", "s" }),
    }

    local lspkind = require "deltavim.lspkind"
    ---@type cmp.ConfigSchema
    return {
      enabled = function()
        if vim.bo[0].buftype == "prompt" then return false end
        ---@diagnostic disable-next-line: undefined-field
        return vim.b.cmp_enabled ~= false or astro.config.features.cmp ~= false
      end,
      snippet = {
        expand = function(args)
          if vim.snippet then vim.snippet.expand(args.body) end
        end,
      },
      formatting = {
        expandable_indicator = true,
        fields = { "kind", "abbr" },
        format = function(_, item)
          item.kind = " "
              .. (lspkind[item.kind] or require("mini.icons").get("default", "lsp"))
              .. " "
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
      sources = {
        { name = "buffer",   priority = 500, group_index = 2 },
        { name = "nvim_lsp", priority = 1000 },
        { name = "path",     priority = 250 },
      },
      mapping = mapping,
    }
  end,

  config = function(_, opts)
    for _, source in ipairs(opts.sources or {}) do
      if not source.group_index then source.group_index = 1 end
    end
    require("cmp").setup(opts)
  end,
}

return Spec
