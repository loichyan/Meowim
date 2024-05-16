return {
  code_action = {
    function() vim.lsp.buf.code_action() end,
    desc = "Select symbol code action",
    cond = "textDocument/codeAction",
  },

  format = {
    function() vim.lsp.buf.format(require("astrolsp").format_opts) end,
    desc = "Format buffer",
    cond = "textDocument/formatting",
  },

  rename = {
    function() vim.lsp.buf.rename() end,
    desc = "Rename current symbol",
    cond = "textDocument/rename",
  },

  refresh_codelens = {
    function() vim.lsp.codelens.refresh() end,
    desc = "Refresh CodeLens",
    cond = "textDocument/codeLens",
  },

  run_codelens = {
    function() vim.lsp.codelens.run() end,
    desc = "Run CodeLens",
    cond = "textDocument/codeLens",
  },

  hover = {
    function() vim.lsp.buf.hover() end,
    desc = "Show symbol details",
    cond = "textDocument/hover",
  },

  hover_signature_help = {
    function() vim.lsp.buf.signature_help() end,
    desc = "Show symbol signature help",
    cond = "textDocument/signatureHelp",
  },

  goto_declaration = {
    function() vim.lsp.buf.declaration() end,
    desc = "Goto symbol declaration",
    cond = "textDocument/declaration",
  },

  goto_definition = {
    function() vim.lsp.buf.definition() end,
    desc = "Goto symbol definition",
    cond = "textDocument/definition",
  },

  goto_type_definition = {
    function() vim.lsp.buf.type_definition() end,
    desc = "Goto symbol type definition",
    cond = "textDocument/typeDefinition",
  },

  list_implementations = {
    function() vim.lsp.buf.implementation() end,
    desc = "List symbol implementations",
    cond = "textDocument/implementation",
  },

  list_references = {
    function() vim.lsp.buf.references() end,
    desc = "List symbol references",
    cond = "textDocument/references",
  },

  list_document_symbols = {
    function() vim.lsp.buf.document_symbol() end,
    desc = "List document symbols",
    cond = "workspace/symbol",
  },

  list_workspace_symbols = {
    function() vim.lsp.buf.workspace_symbol "" end,
    desc = "List workspace symbols",
    cond = "workspace/symbol",
  },

  toggle_buffer_autoformat = {
    function() require("astrolsp.toggles").buffer_autoformat() end,
    desc = "Toggle autoformatting (buffer)",
    cond = "textDocument/formatting",
  },

  toggle_global_autoformat = {
    function() require("astrolsp.toggles").autoformat() end,
    desc = "Toggle autoformatting (global)",
    cond = "textDocument/formatting",
  },

  toggle_buffer_inlay_hints = {
    function() require("astrolsp.toggles").buffer_inlay_hints() end,
    desc = "Toggle inlay hints (buffer)",
    cond = vim.lsp.inlay_hint and "textDocument/inlayHint" or false,
  },

  toggle_global_inlay_hints = {
    function() require("astrolsp.toggles").inlay_hints() end,
    desc = "Toggle inlay hints (global)",
    cond = vim.lsp.inlay_hint and "textDocument/inlayHint" or false,
  },

  toggle_buffer_semantic_tokens = {
    function() require("astrolsp.toggles").buffer_semantic_tokens() end,
    desc = "Toggle semantic highlight (buffer)",
    cond = function(client)
      return client.server_capabilities.semanticTokensProvider and vim.lsp.semantic_tokens
    end,
  },

  toggle_global_codelens = {
    function() require("astrolsp.toggles").codelens() end,
    desc = "Toggle CodeLens (global)",
    cond = "textDocument/codeLens",
  },
}
