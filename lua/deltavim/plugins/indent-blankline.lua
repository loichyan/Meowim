---@type LazyPluginSpec
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = "User AstroFile",
  cmd = {
    "IBLEnable",
    "IBLDisable",
    "IBLToggle",
    "IBLEnableScope",
    "IBLDisableScope",
    "IBLToggleScope",
  },
  ---@type ibl.config
  opts = {
    indent = { char = "▏" },
    scope = {
      enabled = true,
      show_start = false,
      show_end = false,
    },
    exclude = {
      buftypes = {
        "nofile",
        "prompt",
        "quickfix",
        "terminal",
      },
      filetypes = {
        "aerial",
        "alpha",
        "dashboard",
        "help",
        "lazy",
        "mason",
        "neo-tree",
        "NvimTree",
        "neogitstatus",
        "notify",
        "startify",
        "toggleterm",
        "Trouble",
      },
    },
  },
}
