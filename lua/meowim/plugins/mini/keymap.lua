---@type MeoSpec
local Spec = { "mini.keymap", event = "LazyFile" }
local H = {}

Spec.config = function()
  local minikmap = require("mini.keymap")
  minikmap.setup()
  local map_multistep, map_combo = minikmap.map_multistep, minikmap.map_combo

  -- Integrate mini.pairs with mini.completion
  Meow.load("mini.completion")
  Meow.load("mini.pairs") -- Ensure keymaps are set beforehand
  map_multistep("i", "<C-y>", { H.pmenu_accept(true) })
  map_multistep("i", "<CR>", { H.pmenu_accept(true), "minipairs_cr" })
  map_multistep("i", "(", { H.pmenu_accept(), H.minipairs_open("(") })
  map_multistep("i", "<BS>", { "minipairs_bs" })

  -- Better escape
  map_combo("i", "jk", "<BS><BS><Esc>")
  map_combo("i", "jj", "<BS><BS><Esc>")
end

function H.pmenu_accept(force)
  return {
    condition = function() return vim.fn.pumvisible() == 1 and (force or H.pmenu_selected()) end,
    action = function()
      vim.g.minicompletion_confirm = true
      if H.pmenu_selected() then
        return "<C-y>"
      else
        return "<C-n><C-y>"
      end
    end,
  }
end
function H.pmenu_selected() return vim.fn.complete_info({ "selected" }).selected ~= -1 end

function H.minipairs_open(x)
  local info = MiniPairs.config.mappings[x]
  return {
    condition = function() return true end,
    action = function()
      vim.api.nvim_feedkeys(MiniPairs.open(info.pair, info.neigh_pattern), "n", false)
    end,
  }
end

return Spec
