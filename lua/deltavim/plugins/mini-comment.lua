---@type LazyPluginSpec
return {
  "echasnovski/mini.comment",
  dependencies = {
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      lazy = true,
      opts = { enable_autocmd = false },
    },
  },
  keys = function()
    local plugin = require("lazy.core.config").spec.plugins["mini.comment"]
    local opts = require("lazy.core.plugin").values(plugin, "opts", false)

    local mappings = opts.mappings or {}
    return {
      { mappings.comment or "gc", desc = "Comment toggle" },
      { mappings.comment_visual or "gc", mode = "x", desc = "Comment toggle (visual)" },
      { mappings.comment_line or "gcc", desc = "Comment toggle current line" },
      { mappings.textobject or "gc", mode = "o", desc = "Comment lines" },
    }
  end,
  opts = function()
    local cms_ok, cms = pcall(require, "ts_context_commentstring")
    return {
      options = {
        custom_commentstring = function()
          return cms_ok and cms.calculate_commentstring() or vim.bo.commentstring
        end,
        mappings = {
          comment = "gc",
          comment_line = "gcc",
          comment_visual = "gc",
          textobject = "gc",
        },
      },
    }
  end,
}
