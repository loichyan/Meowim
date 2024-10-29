---@module "telescope-fzf-native.nvim"

---@type LazyPluginSpec
local Spec = {
  "nvim-telescope/telescope-fzf-native.nvim",
  lazy = true,
  enabled = vim.fn.executable "make" == 1,
  build = "make",
}

return Spec
