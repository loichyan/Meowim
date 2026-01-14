---@type MeoSpec
local Spec = {
  'nvim-treesitter/nvim-treesitter-textobjects',
  checkout = 'main',
  event = 'LazyFile',
}

Spec.config = function()
  require('nvim-treesitter-textobjects').setup()

  local move = function(action, target) require('nvim-treesitter-textobjects.move')[action](target) end
  -- stylua: ignore
  Meow.keymap({
    { ']a', function() move('goto_next_start',     '@parameter.inner') end, desc = 'Parameter start forward'  },
    { ']A', function() move('goto_next_end',       '@parameter.inner') end, desc = 'Parameter end forward'    },
    { '[a', function() move('goto_previous_start', '@parameter.inner') end, desc = 'Parameter start backward' },
    { '[A', function() move('goto_previous_end',   '@parameter.inner') end, desc = 'Parameter end backward'   },

    { ']c', function() move('goto_next_start',     '@class.outer')     end, desc = 'Class start forward'      },
    { ']C', function() move('goto_next_end',       '@class.outer')     end, desc = 'Class end forward'        },
    { '[c', function() move('goto_previous_start', '@class.outer')     end, desc = 'Class start backward'     },
    { '[C', function() move('goto_previous_end',   '@class.outer')     end, desc = 'Class end backward'       },

    { ']f', function() move('goto_next_start',     '@function.outer')  end, desc = 'Function start forward'   },
    { ']F', function() move('goto_next_end',       '@function.outer')  end, desc = 'Function end forward'     },
    { '[f', function() move('goto_previous_start', '@function.outer')  end, desc = 'Function start backward'  },
    { '[F', function() move('goto_previous_end',   '@function.outer')  end, desc = 'Function end backward'    },
  })
end

return Spec
