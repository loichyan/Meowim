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
  end

  -- Setup keymaps and autocommands once we enter the UI.
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    once = true,
    desc = "meowim.config",
    callback = function()
      require("meowim.config.keymaps")
      if has_file then return end
      require("meowim.config.polish")
      require("meowim.config.autocmds")
    end,
  })
  -- See <https://github.com/LazyVim/LazyVim/blob/ec5981dfb1222c3bf246d9bcaa713d5cfa486fbd/lua/lazyvim/util/plugin.lua#L10>
  Meow.config.event_aliases["LazyFile"] = { "BufReadPre", "BufNewFile" }
end

return Meowim
