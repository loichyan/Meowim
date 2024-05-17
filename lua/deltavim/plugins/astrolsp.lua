---@type LazyPluginSpec
return {
  "AstroNvim/astrolsp",
  lazy = true,
  ---@param opts AstroLSPOpts
  opts = function(_, opts)
    require("deltavim.utils").merge(opts, {
      features = {
        codelens = true,
        inlay_hints = false,
        lsp_handlers = true,
        semantic_tokens = true,
      },
      capabilities = vim.lsp.protocol.make_client_capabilities(),
      ---@diagnostic disable-next-line: missing-fields
      config = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
            },
          },
        },
      },
      flags = {},
      handlers = {
        ---@diagnostic disable-next-line: redefined-local
        function(server, opts) require("lspconfig")[server].setup(opts) end,
      },
      lsp_handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
          border = require("deltavim").get_border "popup_border",
          silent = true,
        }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
          border = require("deltavim").get_border "popup_border",
          silent = true,
        }),
      },
      servers = { "lua_ls" },
      on_attach = nil,
    })
  end,
}
