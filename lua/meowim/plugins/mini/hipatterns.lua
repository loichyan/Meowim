---@type MeoSpec
local Spec = { "mini.hipatterns", event = "LazyFile" }
local H = {}

Spec.config = function()
  local minihipat = require("mini.hipatterns")
  minihipat.setup({
    -- stylua: ignore
    highlighters = {
      hex_color = minihipat.gen_highlighter.hex_color(),
      fixme = { pattern = H.hitodo({ "FIXME" }), group = "MiniHipatternsFixme" },
      hack  = { pattern = H.hitodo({ "HACK" }),  group = "MiniHipatternsHack"  },
      todo  = { pattern = H.hitodo({ "TODO" }),  group = "MiniHipatternsTodo"  },
      note  = { pattern = H.hitodo({ "NOTE" }),  group = "MiniHipatternsNote"  },
    },
  })
end

---Returns Lua patterns used to highlight todo comments.
---@param keywords string[]
---@return string[]
function H.hitodo(keywords)
  local patterns = {}
  for _, kw in ipairs(keywords) do
    table.insert(patterns, "%s?%f[%w]" .. kw .. ":%s+.+") -- KEYWORD: something
    table.insert(patterns, "%s?%f[%w]" .. kw .. "%(.*%):%s+.+") -- KEYWORD(@somebody): something
  end
  return patterns
end

return Spec
