---@type MeoSpec
local Spec = {
  "mini.snippets",
  lazy = true,
  dependencies = { { "rafamadriz/friendly-snippets" } },
}

Spec.config = function()
  local minisnp = require("mini.snippets")
  minisnp.setup({
    snippets = { minisnp.gen_loader.from_lang() },
    -- stylua: ignore
    mappings = {
      expand    = "",
      jump_next = "<Tab>",
      jump_prev = "<S-Tab>",
      stop      = "<C-c>",
    },
  })
  minisnp.start_lsp_server({ match = false })
end

return Spec
