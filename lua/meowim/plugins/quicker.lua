---@type MeoSpec
local Spec = { 'stevearc/quicker.nvim', event = 'LazyFile' }

Spec.config = function()
  require('quicker').setup({
    type_icons = {
      E = 'E ',
      W = 'W ',
      I = 'I ',
      N = 'N ',
      H = 'H ',
    },
  })
end

return Spec
