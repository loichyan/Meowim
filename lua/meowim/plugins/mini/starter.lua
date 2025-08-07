---@type MeoSpec
local Spec = { "mini.starter", lazy = false }

Spec.config = function()
  local ministarter = require("mini.starter")

  local prev_laststatus
  Meow.autocmd("meowim.plugins.mini.starter", {
    {
      event = "BufWinEnter",
      desc = "Restore statusline when MiniStater closed",
      callback = function()
        if prev_laststatus and vim.bo.filetype ~= "ministarter" then
          vim.o.laststatus = prev_laststatus
          prev_laststatus = nil
        end
      end,
    },
  })

  ministarter.setup({
    evaluate_single = true,
    -- stylua: ignore
    items = {
      { section = "Actions", name = "New Buffer",      action = "enew"                                                     },
      { section = "Actions", name = "Restore Session", action = function() Meowim.plugins.mini.sessions.restore() end      },
      { section = "Actions", name = "Files Picker",    action = function() require("mini.pick").registry.smart_files() end },
      { section = "Actions", name = "Grep Picker",     action = function() require("mini.pick").registry.grep_live() end   },
      { section = "Actions", name = "Marks Picker",    action = function() require("mini.pick").registry.marks() end       },
      { section = "Actions", name = "Oldfiles Picker", action = function() require("mini.pick").registry.oldfiles() end    },
      { section = "Actions", name = "Quit Neovim",     action = "qall"                                                     },
      function() Meow.load("mini.sessions") return ministarter.sections.sessions(5, true) end,
    },
    footer = function()
      -- Hide statusline
      if not prev_laststatus then
        prev_laststatus = vim.o.laststatus
        vim.o.laststatus = 0
      end

      local time = _G.meowim_startup_time or 0
      local total = 0
      local loaded = 0
      for _, p in ipairs(Meow:plugins()) do
        if not p:is_shadow() and p:is_enabled() then
          total = total + 1
          if not p:is_lazy() then loaded = loaded + 1 end
        end
      end
      return ("Loaded %d/%d plugins  in %.2fms"):format(loaded, total, time / 1000000)
    end,
    content_hooks = {
      ministarter.gen_hook.adding_bullet(),
      ministarter.gen_hook.indexing("all", { "Actions" }),
      ministarter.gen_hook.aligning("center", "center"),
    },
  })
end

return Spec
