---@type MeoSpec
return {
  "mini.tabline",
  event = "UIEnter",
  config = function() require("mini.tabline").setup() end,
}
