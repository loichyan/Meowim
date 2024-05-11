---@type LazyPluginSpec
return {
  "lewis6991/gitsigns.nvim",

  enabled = vim.fn.executable "git" == 1,
  event = "User AstroGitFile",

  opts = function()
    local icon = require("astroui").get_icon

    ---@type Gitsigns.Config
    ---@diagnostic disable: missing-fields
    return {
      signs = {
        add = { text = icon "GitSign" },
        change = { text = icon "GitSign" },
        delete = { text = icon "GitSign" },
        todeltavimlete = { text = icon "GitSign" },
        changedelete = { text = icon "GitSign" },
        untracked = { text = icon "GitSign" },
      },
      current_line_blame = true,
      preview_config = { border = require("deltavim").get_border "popup_border" },
      worktrees = require("astrocore").config.git_worktrees,
    }
  end,
}
