---@type MeoSpec
local Spec = { "mrjones2014/smart-splits.nvim", event = "VeryLazy" }

Spec.config = function()
  require("smart-splits").setup({
    resize_mode = { quit_key = "q", silent = true },
    ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" },
    ignored_buftypes = { "nofile" },
  })

  local nt = { "n", "t" }
  -- stylua: ignore
  Meow.keymap({
    { "<M-h>", function() require("smart-splits").move_cursor_left() end,  mode = nt, desc = "Goto left window"  },
    { "<M-j>", function() require("smart-splits").move_cursor_down() end,  mode = nt, desc = "Goto down window"  },
    { "<M-k>", function() require("smart-splits").move_cursor_up() end,    mode = nt, desc = "Goto up window"    },
    { "<M-l>", function() require("smart-splits").move_cursor_right() end, mode = nt, desc = "Goto right window" },

    { "<M-H>", function() require("smart-splits").resize_left() end,       mode = nt, desc = "Resize window down"  },
    { "<M-J>", function() require("smart-splits").resize_down() end,       mode = nt, desc = "Resize window left"  },
    { "<M-K>", function() require("smart-splits").resize_up() end,         mode = nt, desc = "Resize window up"    },
    { "<M-L>", function() require("smart-splits").resize_right() end,      mode = nt, desc = "Resize window right" },
  })
end

return Spec
