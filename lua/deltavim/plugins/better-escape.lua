---@module "better-escape.nvim"

---@type LazyPluginSpec
local Spec = {
  "max397574/better-escape.nvim",
  event = "VeryLazy",
  opts = {
    timeout = 300,
    default_mappings = false,
    mappings = {
      i = { j = { k = "<Esc>", j = "<Esc>" } },
    },
  },
}

return Spec
