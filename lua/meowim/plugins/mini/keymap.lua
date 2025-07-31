---@type MeoSpec
return {
  "mini.keymap",
  event = "VeryLazy",
  config = function()
    local keymap = require("mini.keymap")
    local map_multistep, map_combo = keymap.map_multistep, keymap.map_combo
    keymap.setup()

    -- Integrate mini.pairs with mini.completion
    map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
    map_multistep("i", "<BS>", { "minipairs_bs" })

    -- Better escape
    map_combo("i", "jk", "<BS><BS><Esc>")
    map_combo("i", "jj", "<BS><BS><Esc>")
  end,
}
