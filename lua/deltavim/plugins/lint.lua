-- credit:
--   https://github.com/AstroNvim/astrocommunity/blob/c547c9e/lua/astrocommunity/lsp/nvim-lint/init.lua
--   https://github.com/LazyVim/LazyVim/blob/07923f3/lua/lazyvim/plugins/linting.lua
---@type LazyPluginSpec
return {
  "mfussenegger/nvim-lint",
  event = "User AstroFile",
  opts = {
    events = { "BufWritePost", "BufReadPost", "InsertLeave", "TextChanged" },
    debounce = 100,
    linters_by_ft = {
      -- ["_"] = { "xxxxx" }, # fallback linters if no linter is found
      -- ["*"] = { "typos" }, # global linters that are always enabled
    },
    ---@type table<string,table>
    linters = {},
  },
  config = function(_, opts)
    local lint = require "lint"

    for name, linter in pairs(opts.linters or {}) do
      local base = lint.linters[name]
      lint.linters[name] = (type(linter) == "table" and type(base) == "table")
          and vim.tbl_deep_extend("force", base, linter)
        or linter
    end

    lint.linters_by_ft = opts.linters_by_ft
    ---@diagnostic disable-next-line: duplicate-set-field
    lint._resolve_linter_by_ft = require("deltavim.utils").resolve_linters_by_ft

    lint.try_lint()
    vim.api.nvim_create_autocmd(opts.events or { "BufWritePost", "BufReadPost" }, {
      group = vim.api.nvim_create_augroup("auto_lint", { clear = true }),
      desc = "Automatically try linting",
      callback = require("deltavim.utils").debounce(opts.debounce, function() lint.try_lint() end),
    })
  end,
}
