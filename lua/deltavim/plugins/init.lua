-- This file is loaded before all submodules under `deltavim/plugins/`, allowing
-- us to perform some initialization here.

require("deltavim").init()

---@type LazySpec
return {
  { "folke/lazy.nvim", dir = vim.env.LAZY },
  { "loichyan/DeltaVim", lazy = false, priority = 10000 },

  -- add an empty autocmds and mappings tables to prevent nil indexing errors
  {
    "AstroNvim/astrocore",
    opts = function() return { autocmds = {}, mappings = require("astrocore").empty_map_table() } end,
  },
  {
    "AstroNvim/astrolsp",
    opts = function() return { autocmds = {}, mappings = require("astrocore").empty_map_table() } end,
  },
}
