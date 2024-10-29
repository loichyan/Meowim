---@module "telescope.nvim"

---@type LazyPluginSpec
local Spec = {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = { { "telescope-fzf-native.nvim", optional = true } },

  opts = function()
    local actions = require "telescope.actions"
    local icon = require("astroui").get_icon

    return {
      defaults = {
        git_worktrees = require("astrocore").config.git_worktrees,
        prompt_prefix = icon("Selected", 1),
        selection_caret = icon("Selected", 1),
        multi_icon = icon("Selected", 1),
        path_display = { "truncate" },
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "bottom",
            preview_width = 0.55,
          },
          vertical = { mirror = false },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        mappings = {
          i = {
            ["<C-J>"] = actions.cycle_history_next,
            ["<C-K>"] = actions.cycle_history_prev,
            ["<C-T>"] = actions.send_to_qflist + actions.open_qflist,
          },
          n = {
            q = actions.close,
          },
        },
      },
    }
  end,

  config = function(_, opts)
    local telescope = require "telescope"
    telescope.setup(opts)
    local is_available = require("astrocore").is_available
    if is_available "nvim-notify" then telescope.load_extension "notify" end
    if is_available "aerial.nvim" then telescope.load_extension "aerial" end
    if is_available "telescope-fzf-native.nvim" then telescope.load_extension "fzf" end
  end,
}

return Spec
