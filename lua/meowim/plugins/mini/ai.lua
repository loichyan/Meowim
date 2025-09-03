---@type MeoSpec
local Spec = {
  "mini.ai",
  event = "LazyFile",
  dependencies = { "nvim-treesitter" },
}
local H = {}

Spec.config = function()
  local miniai = require("mini.ai")
  local treesitter = miniai.gen_spec.treesitter
  miniai.setup({
    n_lines = 500,
    search_method = "cover",
    custom_textobjects = {
      c = treesitter({ a = "@class.outer", i = "@class.inner" }),
      f = treesitter({ a = "@function.outer", i = "@function.inner" }),
      o = treesitter({
        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
      }),
      g = H.buffer_range,
    },
  })
end

-- Select the entire buffer.
-- Modgified from: https://github.com/LazyVim/LazyVim/blob/ec5981dfb1222c3bf246d9bcaa713d5cfa486fbd/lua/lazyvim/util/mini.lua
function H.buffer_range()
  local startl, endl = 1, vim.fn.line("$")
  return {
    from = {
      line = startl,
      col = 1,
    },
    to = {
      line = endl,
      col = math.max(vim.fn.getline(endl):len(), 1),
    },
  }
end

return Spec
