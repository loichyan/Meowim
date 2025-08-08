---@type MeoSpec
local Spec = { "mini.clue", event = "VeryLazy" }
local H = {}

Spec.config = function()
  local miniclue = require("mini.clue")

  miniclue.setup({
    window = { delay = 250, config = H.smart_width },
    -- stylua: ignore
    clues = {
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.z(),
      { mode = "n", keys = "<Leader>b", desc = "+Buffers"  },
      { mode = "n", keys = "<Leader>f", desc = "+Pickers"  },
      { mode = "n", keys = "<Leader>g", desc = "+Git"      },
      { mode = "n", keys = "<Leader>l", desc = "+LSP"      },
      { mode = "n", keys = "<Leader>q", desc = "+Sessions" },
    },
    triggers = {
      -- builtin_completion
      { mode = "i", keys = "<C-x>" },
      -- marks
      { mode = "n", keys = "'" },
      { mode = "x", keys = "'" },
      { mode = "n", keys = "`" },
      { mode = "x", keys = "`" },
      -- registers
      { mode = "n", keys = '"' },
      { mode = "x", keys = '"' },
      { mode = "i", keys = "<C-r>" },
      { mode = "c", keys = "<C-r>" },
      -- windows
      { mode = "n", keys = "<C-w>" },
      -- g
      { mode = "n", keys = "g" },
      { mode = "x", keys = "g" },
      -- z
      { mode = "n", keys = "z" },
      { mode = "x", keys = "z" },
      -- leaders
      { mode = "n", keys = "<Leader>" },
      { mode = "x", keys = "<Leader>" },
      { mode = "n", keys = "<LocalLeader>" },
      -- bracketed
      { mode = "n", keys = "[" },
      { mode = "n", keys = "]" },
    },
  })
end

---Returns a best-fit width based on the contents and the screen width.
function H.smart_width(bufnr)
  local textwidth = 0
  for _, l in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
    textwidth = math.max(textwidth, vim.fn.strdisplaywidth(l))
  end
  local screen = math.floor(0.5 * vim.o.columns)
  return { width = math.min(textwidth + 1, screen, 50) }
end

return Spec
