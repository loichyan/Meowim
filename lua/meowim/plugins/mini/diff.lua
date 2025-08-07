---@type MeoSpec
return {
  "mini.diff",
  event = "LazyFile",
  config = function()
    require("mini.diff").setup({
      -- stylua: ignore
      mappings = {
        apply      = "gh",
        reset      = "gH",
        textobject = "gh",
        goto_first = "[G",
        goto_prev  = "[g",
        goto_next  = "]g",
        goto_last  = "]G",
      },
    })
  end,
}
