---@module "aerial.nvim"

---@type LazyPluginSpec
local Spec = {
  "stevearc/aerial.nvim",
  event = "User AstroFile",
  opts = function()
    local opts = {
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown", "man" },
      layout = { width = 35 },
      show_guides = true,
      filter_kind = false,
      guides = {
        mid_item = "├ ",
        last_item = "└ ",
        nested_top = "│ ",
        whitespace = "  ",
      },
      keymaps = {
        ["[y"] = "actions.prev",
        ["]y"] = "actions.next",
        ["[Y"] = "actions.prev_up",
        ["]Y"] = "actions.next_up",
        ["{"] = false,
        ["}"] = false,
        ["[["] = false,
        ["]]"] = false,
      },
      icons = require "deltavim.lspkind",
    }

    local large_buf = require("astrocore").config.features.large_buf
    if large_buf then
      opts.disable_max_lines, opts.disable_max_size = large_buf.lines, large_buf.size
    end

    return opts
  end,
}

return Spec
