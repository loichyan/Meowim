---@type MeoSpec
local Spec = {
  "saghen/blink.cmp",
  checkout = "v1.7.0",
  event = "LazyFile",
  dependencies = { "mini.snippets" },
}
local H = {}

Spec.config = function()
  -- stylua: ignore
  local keymap = {
    preset = "none",

    ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<C-l>"]     = { "show_signature", "hide_signature", "fallback" },

    ["<C-e>"]     = { "hide", "fallback" },
    ["<C-y>"]     = { "select_and_accept", "fallback" },
    ["<CR>"]      = { "select_and_accept", H.pair_cr },
    ["("]         = { H.select_and_pair },

    ["<Tab>"]     = { "snippet_forward", "fallback" },
    ["<S-Tab>"]   = { "snippet_backward", "fallback" },

    ["<C-p>"]     = { "select_prev", "fallback" },
    ["<C-n>"]     = { "select_next", "fallback" },
    ["<Up>"]      = { "select_prev", "fallback" },
    ["<Down>"]    = { "select_next", "fallback" },

    ["<C-b>"]     = { "scroll_documentation_up", "fallback" },
    ["<C-f>"]     = { "scroll_documentation_down", "fallback" },
  }

  -- stylua: ignore
  local cmdline_keymap = {
    preset = "none",

    ["<C-Space>"] = { "show", "fallback" },

    ["<C-e>"]     = { "cancel", "fallback" },
    ["<C-y>"]     = { "select_and_accept", "fallback" },
    ["<CR>"]      = { "accept_and_enter", "fallback" },

    ["<Tab>"]     = { "show_and_insert_or_accept_single", "select_next", "fallback" },
    ["<S-Tab>"]   = { "show_and_insert_or_accept_single", "select_prev", "fallback" },

    ["<C-n>"]     = { "select_next", "fallback" },
    ["<C-p>"]     = { "select_prev", "fallback" },
    ["<Right>"]   = { "select_next", "fallback" },
    ["<Left>"]    = { "select_prev", "fallback" },
  }

  local draw_with_miniicon = {
    components = {
      kind_icon = {
        text = function(ctx)
          local icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
          return icon
        end,
        highlight = function(ctx)
          local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
          return hl
        end,
      },
      kind = {
        highlight = function(ctx)
          local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
          return hl
        end,
      },
    },
  }

  require("blink.cmp").setup({
    enabled = function() return not Meowim.utils.is_toggle_on(0, "completion_disable") end,
    -- General
    completion = {
      accept = { auto_brackets = { enabled = false } },
      list = { selection = { preselect = false, auto_insert = true } },
      menu = { draw = draw_with_miniicon, auto_show_delay_ms = 150, winblend = 30 },
      documentation = { auto_show = true, auto_show_delay_ms = 150, window = { winblend = 30 } },
      ghost_text = { enabled = false },
    },
    signature = { enabled = true, window = { winblend = 30 } },
    -- Completion
    fuzzy = {
      implementation = "prefer_rust_with_warning",
      sorts = { "exact", "score", "sort_text", "kind" },
    },
    snippets = { preset = "mini_snippets" },
    sources = {
      default = { "path", "lsp", "snippets", "buffer" },
      min_keyword_length = 2,
      providers = {
        lsp = { fallbacks = {} },
      },
    },
    -- keymaps
    keymap = keymap,
    cmdline = { enabled = true, keymap = cmdline_keymap },
    term = { enabled = false },
  })
end

H.pair_cr = function()
  vim.api.nvim_feedkeys(require("mini.pairs").cr(), "n", false)
  return true
end

H.select_and_pair = function(cmp)
  if cmp.is_active() and not cmp.get_selected_item_idx() then cmp.insert_next() end
  vim.schedule(function()
    cmp.hide()
    local info = require("mini.pairs").config.mappings["("]
    vim.api.nvim_feedkeys(require("mini.pairs").open(info.pair, info.neigh_pattern), "n", false)
  end)
  return true
end

return Spec
