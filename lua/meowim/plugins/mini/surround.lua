---@type MeoSpec
local Spec = { 'mini.surround', event = 'LazyFile' }

Spec.config = function()
  require('mini.surround').setup({
    n_lines = 500,
    search_method = 'cover',
    -- stylua: ignore
    mappings = {
      add            = 'yz',
      delete         = 'dz',
      replace        = 'cz',
      find           = 'gzf',
      find_left      = 'gzF',
      highlight      = 'gzh',
      update_n_lines = 'gzn',
      suffix_last    = 'l',
      suffix_next    = 'n',
    },
    custom_surroundings = {
      ['T'] = {
        -- Match: Type< ... >
        --        ^^^^^     ^
        input = { '%f[%w_][%w_]+%b<>', '^.-<().*()>$' },
        output = function()
          local input = MiniSurround.user_input('Type')
          if input == nil then return nil end
          local type = input:match('^%S*')
          return { left = type .. '<', right = '>' }
        end,
      },
    },
  })
end

return Spec
