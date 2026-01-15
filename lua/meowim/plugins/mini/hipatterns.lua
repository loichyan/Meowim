---@type MeoSpec
local Spec = { 'mini.hipatterns', event = 'LazyFile' }
local H = {}

Spec.config = function()
  local minihipat = require('mini.hipatterns')
  minihipat.setup({
    -- stylua: ignore
    highlighters = {
      hex_color = minihipat.gen_highlighter.hex_color(),
      fixme = H.hitodo({ 'FIXME' }, 'F', 'MiniHipatternsFixme'),
      hack  = H.hitodo({ 'HACK'  }, 'H', 'MiniHipatternsHack'),
      todo  = H.hitodo({ 'TODO'  }, 'T', 'MiniHipatternsTodo'),
      note  = H.hitodo({ 'NOTE'  }, 'N', 'MiniHipatternsNote'),
    },
  })
end

---Returns Lua patterns used to highlight todo comments.
---@param keywords string[]
---@param sign string
---@param group string
H.hitodo = function(keywords, sign, group)
  local pattern = {}
  for _, kw in ipairs(keywords) do
    table.insert(pattern, '%f[%w]' .. kw .. ':%s+.+$') -- KEYWORD: something
    table.insert(pattern, '%f[%w]' .. kw .. '%(.*%):%s+.+$') -- KEYWORD(@somebody): something
  end
  return {
    pattern = pattern,
    group = group,
    extmark_opts = {
      sign_text = sign,
      sign_hl_group = group .. 'Sign',
      priority = vim.hl.priorities.diagnostics - 1,
    },
  }
end

return Spec
