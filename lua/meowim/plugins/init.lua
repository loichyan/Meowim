---@type MeoSpecs
return {
  { "loichyan/meow.nvim", lazy = false, priority = math.huge },
  { "nvim-mini/mini.nvim", lazy = false, priority = math.huge },
  { import = "meowim.plugins.mini" },
  { "meowim", shadow = true, lazy = false, config = function() require("meowim").setup() end },
}
