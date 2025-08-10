---@type MeoSpec
local Spec = { "mini.git", event = "LazyFile" }

Spec.config = function()
  require("mini.git").setup()

  ---@type MeoKeySpec[]
  -- stylua: ignore
  local mappings = {
    { "q",    "<Cmd>lua Meowim.utils.try_close()<CR>", desc = "Close current buffer" },
    { "<CR>", "<Cmd>lua MiniGit.show_at_cursor()<CR>", desc = "Show cursor info"     },
  }
  Meow.autocmd("meowim.plugins.mini.git", {
    {
      event = "BufEnter",
      desc = "Set useful mappings for Git related files",
      callback = function(ev)
        local ft = vim.bo.filetype
        local is_git = ev.file:find("^minigit://%d+/") or ft == "git" or ft == "diff"
        if is_git then Meow.keymap(ev.buf, mappings) end
      end,
    },
  })
end

return Spec
