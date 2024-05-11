---@type LazyPluginSpec
return {
  "AstroNvim/astrolsp",
  ---@param opts AstroLSPOpts
  opts = function(_, opts)
    require("deltavim.utils").merge(opts.autocmds, {
      lsp_codelens_refresh = {
        cond = "textDocument/codeLens",
        {
          event = { "InsertLeave", "BufEnter" },
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then
              ---@diagnostic disable-next-line: redundant-parameter
              vim.lsp.codelens.refresh { bufnr = args.buf }
            end
          end,
        },
      },

      lsp_autoformat = {
        cond = require("deltavim.utils").formatting_enabled,
        {
          event = "BufWritePre",
          desc = "autoformat on save",
          callback = function(_, _, bufnr)
            local astrolsp, utils = require "astrolsp", require "deltavim.utils"
            local config = assert(astrolsp.config.formatting.format_on_save)

            local buf_enabled = vim.b[bufnr].autoformat
            if buf_enabled == nil then buf_enabled = config.enabled end
            if buf_enabled and ((not config.filter) or config.filter(bufnr)) then
              vim.lsp.buf.format(utils.merge({}, astrolsp.format_opts, { bufnr = bufnr }))
            end
          end,
        },
      },
    })
  end,
}
