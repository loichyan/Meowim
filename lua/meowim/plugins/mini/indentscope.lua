---@type MeoSpec
local Spec = { "mini.indentscope", event = "LazyFile" }

Spec.config = function()
  local miniindent = require("mini.indentscope")
  miniindent.setup({
    symbol = "│",
    draw = {
      delay = 0,
      animation = miniindent.gen_animation.none(),
    },
    mappings = {
      object_scope = "ii",
      object_scope_with_border = "ai",
      -- configured in mini.bracked
      goto_top = "",
      goto_bottom = "",
    },
  })
end

return Spec
