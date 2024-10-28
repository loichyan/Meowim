---@module "which-key.nvim"

---@type LazyPluginSpec
local Spec = {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = function()
    return {
      preset = "classic",
      icons = {
        group = vim.g.icons_enabled ~= false and "" or "+",
        separator = "-",
        rules = false,
      },
      disable = { ft = { "TelescopePrompt" } },
    }
  end,
}

return Spec
