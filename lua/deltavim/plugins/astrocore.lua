---@type LazyPluginSpec
return {
  "AstroNvim/astrocore",
  lazy = false,
  priority = 10000,
  dependencies = { "AstroNvim/astroui" },

  ---@param opts AstroCoreOpts
  opts = function(_, opts)
    local icon = require("astroui").get_icon

    require("deltavim.utils").merge(opts, {
      features = {
        large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files
        autopairs = true, -- enable autopairs at start
        cmp = true, -- enable completion at start
        diagnostics_mode = 3, -- enable diagnostics by default
        highlighturl = true, -- highlight URLs by default
        notifications = true, -- disable notifications
      },
      diagnostics = {
        virtual_text = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = icon "DiagnosticError",
            [vim.diagnostic.severity.HINT] = icon "DiagnosticHint",
            [vim.diagnostic.severity.WARN] = icon "DiagnosticWarn",
            [vim.diagnostic.severity.INFO] = icon "DiagnosticInfo",
          },
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
          focused = false,
          style = "minimal",
          border = require("deltavim").get_border "popup_border",
          source = "always",
          header = "",
          prefix = "",
        },
      },
      rooter = {
        detector = {
          "lsp",
          { ".git", "_darcs", ".hg", ".bzr", ".svn" },
          { "lua", "MakeFile", "package.json" },
        },
        ignore = {
          servers = {},
          dirs = {},
        },
        autochdir = false,
        scope = "global",
        notify = false,
      },
      sessions = {
        autosave = { last = true, cwd = true },
        ignore = {
          dirs = {},
          filetypes = { "gitcommit", "gitrebase" },
          buftypes = {},
        },
      },
    })
  end,
}
