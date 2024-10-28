---@module "smart-splits.nvim"

---@type LazyPluginSpec
local Spec = {
  "mrjones2014/smart-splits.nvim",
  event = "VeryLazy",
  opts = {
    resize_mode = { quit_key = "q", silent = true },
    ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" },
    ignored_buftypes = { "nofile" },
  },
}

return Spec
