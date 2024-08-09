local lspkind, icons = {}, require "mini.icons"

for _, kind in ipairs(vim.lsp.protocol.CompletionItemKind) do
  lspkind[kind] = icons.get("lsp", kind)
end
for _, kind in ipairs(vim.lsp.protocol.SymbolKind) do
  lspkind[kind] = icons.get("lsp", kind)
end

return lspkind
