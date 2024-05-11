---@type LazyPluginSpec
return {
  "stevearc/resession.nvim",
  lazy = true,
  dependencies = {
    {
      "AstroNvim/astrocore",
      optional = true,
      opts = function(_, opts)
        require("deltavim.utils").merge(opts.autocmds, {
          resession_auto_save = {
            {
              event = "VimLeavePre",
              desc = "Save session on exit",
              callback = function()
                local ok, resession = pcall(require, "resession")
                if not ok then return end

                local astro_buf = require "astrocore.buffer"
                local autosave = astro_buf.sessions.autosave
                if autosave and astro_buf.is_valid_session() then
                  if autosave.last then resession.save("last", { notify = false }) end
                  if autosave.cwd then
                    resession.save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
                  end
                end
              end,
            },
          },
        })
      end,
    },
  },
  opts = {
    buf_filter = function(bufnr) return require("astrocore.buffer").is_restorable(bufnr) end,
    tab_buf_filter = function(tabpage, bufnr) return vim.tbl_contains(vim.t[tabpage].bufs, bufnr) end,
    extensions = { astrocore = { enable_in_tab = true } },
  },
}
