---@type MeoSpec
local Spec = { "mini.surround", event = "LazyFile" }

Spec.config = function()
  require("mini.surround").setup({
    n_lines = 500,
    search_method = "cover",
    -- stylua: ignore
    mappings = {
      add            = "yz",
      delete         = "dz",
      replace        = "cz",
      find           = "gzf",
      find_left      = "gzF",
      highlight      = "gzh",
      update_n_lines = "gzn",
      suffix_last    = "l",
      suffix_next    = "n",
    },
  })
end

return Spec
