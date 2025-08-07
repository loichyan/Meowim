local Meowim = {}

local did_setup = false
function Meowim.setup()
  if did_setup then return end
  did_setup = true

  require("meowim.config.options")

  -- Load autocommands and polishment early if Vim is about to open files.
  local has_file = vim.fn.argc(-1) > 0
  if has_file then
    require("meowim.config.polish")
    require("meowim.config.autocmds")
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
        require("meowim.config.keymaps")
        if has_file then return end
        require("meowim.config.polish")
        require("meowim.config.autocmds")
      end,
    },
  })

  -- See <https://github.com/LazyVim/LazyVim/blob/ec5981dfb1222c3bf246d9bcaa713d5cfa486fbd/lua/lazyvim/util/plugin.lua#L10>
  Meow.config.event_aliases["LazyFile"] = { "BufReadPost", "BufWritePre", "BufNewFile" }
end

return Meowim
