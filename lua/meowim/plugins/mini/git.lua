---@type MeoSpec
return {
  "mini.git",
  event = "LazyFile",
  config = function() require("mini.git").setup() end,
}
