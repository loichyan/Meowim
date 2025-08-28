---@type MeoSpec
local Spec = { "mini.brackted", event = "LazyFile" }

Spec.config = function()
  -- stylua: ignore
  require("mini.bracketed").setup({
    buffer     = { suffix = ""  },
    comment    = { suffix = ""  },
    conflict   = { suffix = "x" },
    diagnostic = { suffix = ""  },
    file       = { suffix = ""  },
    indent     = { suffix = "i" },
    jump       = { suffix = ""  },
    location   = { suffix = "l" },
    oldfile    = { suffix = ""  },
    quickfix   = { suffix = "q" },
    treesitter = { suffix = ""  },
    undo       = { suffix = ""  },
    window     = { suffix = ""  },
    yank       = { suffix = ""  },
  })

  local nxo = { "n", "x", "o" }
  -- stylua: ignore
  Meow.keymap({
    { "[gc", function() require("mini.bracketed").comment("backward") end, mode = nxo, desc = "Comment backward" },
    { "[gC", function() require("mini.bracketed").comment("first") end,    mode = nxo, desc = "Comment first"    },
    { "]gc", function() require("mini.bracketed").comment("forward") end,  mode = nxo, desc = "Comment forward"  },
    { "]gC", function() require("mini.bracketed").comment("last") end,     mode = nxo, desc = "Comment last"     },
  })
end

return Spec
