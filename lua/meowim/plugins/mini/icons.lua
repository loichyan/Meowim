---@type MeoSpec
local Spec = { 'mini.icons', event = 'UIEnter' }

Spec.config = function()
  local lsp = {}
  for kind, glyph in pairs(require('meowim.lspkind')) do
    lsp[kind:lower()] = { glyph = glyph }
  end
  require('mini.icons').setup({ lsp = lsp })
end

return Spec
