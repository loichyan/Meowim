local Meowim = {}

local did_setup = false
Meowim.setup = function()
  if did_setup then return end
  did_setup = true

  _G.Meowim = Meowim

  -- Load configurations, reporting error if failed.
  local load = function(mod)
    local ok, err = pcall(require, mod)
    if not ok then Meow.notifyf("ERROR", "failed to load '%s': %s", mod, err) end
  end

  -- Load options on startup anyway.
  load("meowim.config.options")

  -- Load autocommands and polishment early if Vim is about to open files.
  local has_file = vim.fn.argc(-1) > 0
  if has_file then
    load("meowim.config.polish")
    load("meowim.config.autocmds")
    -- Load treesitter (for highlighting) and LSP configurations immediately to
    -- make sure they can work properly.
    Meow.load("nvim-treesitter")
    Meow.load("nvim-lspconfig")
  end

  -- Setup keymaps and autocommands once we enter the UI.
  Meow.autocmd("meowim.setup", {
    {
      event = "User",
      pattern = "VeryLazy",
      desc = "Load user configurations",
      once = true,
      callback = function()
        load("meowim.config.keymaps")
        if has_file then return end
        load("meowim.config.polish")
        load("meowim.config.autocmds")
      end,
    },
  })

  -- See <https://github.com/LazyVim/LazyVim/blob/ec5981dfb1222c3bf246d9bcaa713d5cfa486fbd/lua/lazyvim/util/plugin.lua#L10>
  Meow.config.event_aliases["LazyFile"] = { "BufReadPre", "BufWritePre", "BufNewFile" }
end

---@module "meowim.utils"
Meowim.utils = setmetatable({}, {
  __index = function(_, k) return require("meowim.utils")[k] end,
})

---Returns `meowim.plugins.{key}`.
---@class meowim.plugins
Meowim.plugins = setmetatable({}, {
  __index = function(t, k)
    t[k] = require("meowim.plugins." .. k)
    return t[k]
  end,
})

---Returns `meowim.plugins.mini.{key}`.
---@class meowim.plugins.mini
Meowim.plugins.mini = setmetatable({}, {
  __index = function(t, k)
    t[k] = require("meowim.plugins.mini." .. k)
    return t[k]
  end,
})

return Meowim
