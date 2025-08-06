---@type MeoSpec
local Spec = { "mini.keymap", event = "VeryLazy" }

Spec.config = function()
  local minikeymap = require("mini.keymap")
  local map_multistep, map_combo = minikeymap.map_multistep, minikeymap.map_combo
  minikeymap.setup()

  -- Integrate mini.pairs with mini.completion
  map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
  map_multistep("i", "<BS>", { "minipairs_bs" })

  -- Better escape
  map_combo("i", "jk", "<BS><BS><Esc>")
  map_combo("i", "jj", "<BS><BS><Esc>")
end

return Spec
