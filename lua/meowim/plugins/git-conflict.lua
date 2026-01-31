---@type MeoSpec
local Spec = { 'akinsho/git-conflict.nvim', event = 'LazyFile' }

Spec.config = function()
  require('git-conflict').setup({
    default_mappings = false,
    default_commands = false,
    disable_diagnostics = true,
  })
end

return Spec
