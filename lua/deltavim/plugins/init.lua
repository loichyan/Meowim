require("deltavim").init()

---@type LazySpec
return {
  { "folke/lazy.nvim", dir = vim.env.LAZY },
  { "loichyan/DeltaVim", lazy = false, priority = 10000 },

  {
    "AstroNvim/astrocore",
    lazy = false,
    priority = 10000,
    dependencies = { "AstroNvim/astroui" },
    opts = function()
      return {
        autocmds = {},
        mappings = require("astrocore").empty_map_table(),
        options = {},
      }
    end,
  },

  {
    "AstroNvim/astrolsp",
    lazy = true,
    opts = function()
      return {
        autocmds = {},
        mappings = require("astrocore").empty_map_table(),
      }
    end,
  },

  { "AstroNvim/astroui", lazy = true },
}
