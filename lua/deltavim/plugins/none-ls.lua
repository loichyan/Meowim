return {
  "nvimtools/none-ls.nvim",
  main = "null-ls",
  event = "User AstroFile",
  dependencies = {
    { "AstroNvim/astrolsp", optional = true },
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  opts = function()
    return {
      on_attach = require("astrolsp").on_attach,
      border = require("deltavim").get_border "float_border",
    }
  end,
  config = function(_, opts)
    local nls = require "null-ls"

    -- add formatters and linters defined in astrolsp
    local sources = opts.sources or {}
    local lsp_config = require("astrolsp").config ---@cast lsp_config +{formatters?:table,linters?:table}
    for name, args in pairs(lsp_config.formatters or {}) do
      args = args == true and {} or args
      if args then table.insert(sources, nls.builtins.formatting[name].with(args)) end
    end
    for name, args in pairs(lsp_config.linters or {}) do
      args = args == true and {} or args
      if args then table.insert(sources, nls.builtins.diagnostics[name].with(args)) end
    end
    opts.sources = sources

    nls.setup(opts)
  end,
}
