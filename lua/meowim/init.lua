local Meowim = {}

local did_setup = false
function Meowim.setup()
  if did_setup then return end
  did_setup = true

  require("meowim.config.options")
  -- Setup keymaps and autocommands once we enter the UI.
  vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    desc = "meowim.config",
    callback = function()
      require("meowim.config.keymaps")
      require("meowim.config.autocmds")
      require("meowim.config.polish")
    end,
  })
  -- See <https://github.com/LazyVim/LazyVim/blob/ec5981dfb1222c3bf246d9bcaa713d5cfa486fbd/lua/lazyvim/util/plugin.lua#L10>
  Meow.config.event_aliases["LazyFile"] = { "BufReadPre", "BufNewFile" }
end

return Meowim
