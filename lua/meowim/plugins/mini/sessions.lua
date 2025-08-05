---@type MeoSpec
return {
  "mini.sessions",
  event = "VeryLazy",
  config = function()
    require("mini.sessions").setup({
      autoread = false,
      autowrite = false,
    })

    vim.api.nvim_create_autocmd("VimLeavePre", {
      desc = "Save session on exit",
      once = true,
      callback = function() require("meowim.utils").session_save() end,
    })
  end,
}
