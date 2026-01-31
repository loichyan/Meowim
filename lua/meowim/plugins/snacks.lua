---@type MeoSpec
local Spec = {
  'folke/snacks.nvim',
  lazy = false,
  priority = 90,
}

Spec.config = function()
  require('snacks').setup({
    quickfile = { enabled = true },
    input = { enabled = true },
    words = { enabled = true, debounce = 300 },
  })
  Meow.autocmd('meowim.plugins.snacks', {
    {
      event = 'User',
      pattern = 'MiniFilesActionRename',
      desc = 'Track renamed files',
      callback = function(ev) require('snacks.rename').on_rename_file(ev.data.from, ev.data.to) end,
    },
  })
end

return Spec
