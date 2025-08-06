---@type MeoSpec
local Spec = { "folke/lazydev.nvim", ft = "lua" }

Spec.config = function()
  ---@diagnostic disable-next-line:missing-fields
  require("lazydev").setup({
    library = {
      "meow.nvim",
      "mini.nvim",
      { path = "${3rd}/luv/library", words = { "vim%.loop", "vim%.uv" } },
    },
  })
end

return Spec
