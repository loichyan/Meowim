---@type LazyPluginSpec
return {
  "nvimtools/none-ls.nvim",
  main = "null-ls",
  event = "User AstroFile",
  dependencies = { { "astrolsp", optional = true } },
  opts = function()
    return {
      on_attach = require("astrolsp").on_attach,
      border = require("deltavim").get_border "float_border",
    }
  end,
}
