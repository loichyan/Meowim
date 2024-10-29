---@module "cmp-nvim-lsp"

---@type LazyPluginSpec
local Spec = {
  "hrsh7th/cmp-nvim-lsp",
  lazy = true,
  specs = {
    {
      "astrolsp",
      optional = true,
      opts = {
        capabilities = {
          textDocument = {
            completion = {
              completionItem = {
                documentationFormat = { "markdown", "plaintext" },
                snippetSupport = true,
                preselectSupport = true,
                insertReplaceSupport = true,
                labelDetailsSupport = true,
                deprecatedSupport = true,
                commitCharactersSupport = true,
                tagSupport = { valueSet = { 1 } },
                resolveSupport = {
                  properties = { "documentation", "detail", "additionalTextEdits" },
                },
              },
            },
          },
        },
      },
    },
  },
}

return Spec
