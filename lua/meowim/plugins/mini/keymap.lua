---@type MeoSpec
local Spec = { 'mini.keymap', event = 'LazyFile' }

Spec.config = function()
  local minikmap = require('mini.keymap')
  minikmap.setup()
  local map_multistep, map_combo = minikmap.map_multistep, minikmap.map_combo

  -- Integrate mini.pairs
  Meow.load('mini.pairs') -- Ensure keymaps are set beforehand
  -- '<CR>' is handled in the configurations for blink.cmp
  map_multistep('i', '<BS>', { 'minipairs_bs' })

  -- Better escape
  map_combo('i', 'jk', '<BS><BS><Esc>')
  map_combo('i', 'jj', '<BS><BS><Esc>')
end

return Spec
