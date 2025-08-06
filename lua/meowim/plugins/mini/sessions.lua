---@type MeoSpec
local Spec = { "mini.sessions", event = "VeryLazy" }

Spec.config = function()
  require("mini.sessions").setup({
    autoread = false,
    autowrite = false,
  })

  Meow.autocmd("meowim.plugins.mini.sessions", {
    {
      event = "VimLeavePre",
      desc = "Save session on exit",
      once = true,
      callback = function() require("meowim.utils").session_save() end,
    },
  })
end

return Spec
