---@type MeoSpec
return {
  'loichyan/meoline.nvim',
  event = 'UIEnter',
  config = function() require('meoline').setup() end,
}
