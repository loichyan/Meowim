---@type MeoSpec
local Spec = { "mini.hipatterns", event = "LazyFile" }

---Returns Lua patterns used to highlight todo comments.
---@param keywords string[]
---@return string[]
local hitodo = function(keywords)
  local patterns = {}
  for _, kw in ipairs(keywords) do
    table.insert(patterns, "%s?%f[%w]" .. kw .. ":%s+.+") -- KEYWORD: something
    table.insert(patterns, "%s?%f[%w]" .. kw .. "%(.*%):%s+.+") -- KEYWORD(@somebody): something
  end
  return patterns
end

Spec.config = function()
  local minihipat = require("mini.hipatterns")
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
