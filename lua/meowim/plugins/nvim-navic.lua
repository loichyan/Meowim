---@type MeoSpec
local Spec = { "SmiteshP/nvim-navic", event = "LazyFile" }

Spec.config = function()
  require("nvim-navic").setup({
    icons = { enabled = false },
    lsp = { auto_attach = true },
    highlight = false,
    lazy_update_context = false,
  })
end

return Spec
