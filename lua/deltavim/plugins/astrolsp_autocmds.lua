---@type LazyPluginSpec
return {
  "astrolsp",
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
    })
  end,
}
