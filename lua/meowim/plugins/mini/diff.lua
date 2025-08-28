---@type MeoSpec
local Spec = { "mini.diff", event = "LazyFile" }

Spec.config = function()
  require("mini.diff").setup({
    -- stylua: ignore
    mappings = {
      apply      = "gh",
      reset      = "gH",
      textobject = "gh",
      goto_prev  = "",
      goto_next  = "",
      goto_first = "",
      goto_last  = "",
    },
    options = {
      wrap_goto = true,
    },
  })

  local do_cursor = function(mode)
    return require("mini.diff").operator(mode) .. "<Cmd>lua MiniDiff.textobject()<CR>"
  end
  local do_buffer = function(mode) require("mini.diff").do_hunks(0, mode) end

  local nxo = { "n", "x", "o" }
  -- stylua: ignore
  Meow.keymap({
    { "ghh", function() return do_cursor("apply") end, expr = true, desc = "Stage cursor hunks" },
    { "gHh", function() return do_cursor("reset") end, expr = true, desc = "Reset cursor hunks" },
    { "ghH", function() return do_buffer("apply") end,              desc = "Stage buffer hunks" },
    { "gHH", function() return do_buffer("reset") end,              desc = "Reset buffer hunks" },

    { "[gh", function() require("mini.diff").goto_hunk("prev") end,  mode = nxo, desc = "Hunk backward" },
    { "[gH", function() require("mini.diff").goto_hunk("first") end, mode = nxo, desc = "Hunk first"    },
    { "]gh", function() require("mini.diff").goto_hunk("next") end,  mode = nxo, desc = "Hunk forward"  },
    { "]gH", function() require("mini.diff").goto_hunk("last") end,  mode = nxo, desc = "Hunk last"     },
  })
end

return Spec
