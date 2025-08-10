---@type MeoSpec
local Spec = { "mini.diff", event = "LazyFile" }

Spec.config = function()
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

  local do_cursor = function(mode)
    return require("mini.diff").operator(mode) .. "<Cmd>lua MiniDiff.textobject()<CR>"
  end
  local do_buffer = function(mode) require("mini.diff").do_hunks(0, mode) end

  -- stylua: ignore
  Meow.keymap({
    { "ghh", function() return do_cursor("apply") end, expr = true, desc = "Stage cursor hunks" },
    { "gHh", function() return do_cursor("reset") end, expr = true, desc = "Reset cursor hunks" },
    { "ghH", function() return do_buffer("apply") end,              desc = "Stage buffer hunks" },
    { "gHH", function() return do_buffer("reset") end,              desc = "Reset buffer hunks" },
  })
end

return Spec
