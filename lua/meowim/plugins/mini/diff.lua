---@type MeoSpec
local Spec = { "mini.diff", event = "VeryLazy" }

Spec.config = function()
  require("mini.diff").setup({
    mappings = {
      apply = "gh",
      reset = "gH",
      textobject = "gh",
      goto_first = "[G",
      goto_prev = "[g",
      goto_next = "]g",
      goto_last = "]G",
    },
  })
end

return Spec
