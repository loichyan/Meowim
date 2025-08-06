---@type MeoSpec
local Spec = { "mini.misc", event = "VeryLazy" }

Spec.config = function()
  local minimisc = require("mini.misc")
  minimisc.setup({ make_global = { "put", "put_text", "bench_time", "stat_summary" } })
  minimisc.setup_restore_cursor()

  -- Setup auto root directory discovery
  local root_patterns = { ".git" }
  vim.o.autochdir = false
  Meow.autocmd("meowim.plugins.mini.misc", {
    {
      event = "BufEnter",
      desc = "Find root and change current directory",
      nested = true,
      callback = vim.schedule_wrap(function(data)
        if data.buf ~= vim.api.nvim_get_current_buf() then return end
        -- Ignore non-file buffers
        if vim.bo.buftype ~= "" then return end
        local root = MiniMisc.find_root(data.buf, root_patterns)
        if root ~= nil then vim.fn.chdir(root) end
      end),
    },
  })

  Meow.keymap({
    { "<Leader>m", function() require("mini.misc").zoom() end, desc = "Zoom current buffer" },
  })
end

return Spec
