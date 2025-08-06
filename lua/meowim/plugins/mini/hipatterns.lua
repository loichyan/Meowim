---@type MeoSpec
local Spec = { "mini.hipatterns", event = "LazyFile" }

Spec.config = function()
  local minihipat = require("mini.hipatterns")
  local hitodo = require("meowim.utils").hipattern_todo
  minihipat.setup({
    -- stylua: ignore
    highlighters = {
      hex_color = minihipat.gen_highlighter.hex_color(),
      fixme = { pattern = hitodo({ "FIXME" }), group = "MiniHipatternsFixme" },
      hack  = { pattern = hitodo({ "HACK" }),  group = "MiniHipatternsHack"  },
      todo  = { pattern = hitodo({ "TODO" }),  group = "MiniHipatternsTodo"  },
      note  = { pattern = hitodo({ "NOTE" }),  group = "MiniHipatternsNote"  },
    },
  })
end

return Spec
