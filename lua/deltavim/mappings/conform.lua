---@diagnostic disable: inject-field
return {
  { cond = "conform.nvim" },

  format = {
    "<Cmd>Format<CR>",
    desc = "Format buffer",
  },

  toggle_buffer = {
    function()
      if vim.b.autoformat == nil then vim.b.autoformat = vim.g.autoformat end
      vim.b.autoformat = not (vim.b.autoformat ~= false)
      require("astrocore").notify("Buffer autoformatting " .. (vim.b.autoformat and "on" or "off"))
    end,
    desc = "Toggle autoformatting (buffer)",
  },

  toggle_global = {
    function()
      vim.g.autoformat = not (vim.g.autoformat ~= false)
      vim.b.autoformat = nil
      require("astrocore").notify("Global autoformatting " .. (vim.g.autoformat and "on" or "off"))
    end,
    desc = "Toggle autoformatting (global)",
  },
}
