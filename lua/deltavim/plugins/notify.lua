return {
  "rcarriga/nvim-notify",
  lazy = true,
  init = function() require("astrocore").load_plugin_with_func("nvim-notify", vim, "notify") end,
  opts = function()
    local icon = require("astroui").get_icon
    return {
      icons = {
        DEBUG = icon "Debugger",
        ERROR = icon "DiagnosticError",
        INFO = icon "DiagnosticInfo",
        TRACE = icon "DiagnosticHint",
        WARN = icon "DiagnosticWarn",
      },
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.75) end,
      on_open = function(win)
        local astro = require "astrocore"
        vim.api.nvim_win_set_config(win, { zindex = 175 })
        if not astro.config.features.notifications then
          vim.api.nvim_win_close(win, true)
          return
        end

        -- enable syntax highlighting
        if astro.is_available "nvim-treesitter" then
          require("lazy").load { plugins = { "nvim-treesitter" } }
        end
        vim.wo[win].conceallevel = 3
        vim.wo[win].spell = false
        local buf = vim.api.nvim_win_get_buf(win)
        if not pcall(vim.treesitter.start, buf, "markdown") then vim.bo[buf].syntax = "markdown" end
      end,
    }
  end,
  config = function(_, opts)
    local notify = require "notify"
    notify.setup(opts)
    require("deltavim.notify").setup(notify)
  end,
}
