---@type LazyPluginSpec
return {
  "kevinhwang91/nvim-ufo",
  event = { "User AstroFile", "InsertEnter" },
  dependencies = {
    { "kevinhwang91/promise-async", lazy = true },
    {
      "AstroNvim/astrolsp",
      optional = true,
      opts = {
        capabilities = {
          textDocument = {
            foldingRange = { dynamicRegistration = false, lineFoldingOnly = true },
          },
        },
      },
    },
  },

  opts = function()
    local function handleFallbackException(bufnr, err, providerName)
      if type(err) == "string" and err:match "UfoFallbackException" then
        return require("ufo").getFolds(bufnr, providerName)
      else
        return require("promise").reject(err)
      end
    end

    ---@type UfoConfig
    return {
      preview = {
        win_config = {
          border = require("deltavim").get_border("popup_border", "Folded"),
        },
        mappings = {
          scrollB = "<C-b>",
          scrollF = "<C-f>",
          scrollU = "<C-u>",
          scrollD = "<C-d>",
        },
      },
      provider_selector = function(_, filetype, buftype)
        return (filetype == "" or buftype == "nofile") and "indent" -- only use indent until a file is opened
          or function(bufnr)
            return require("ufo")
              .getFolds(bufnr, "lsp")
              :catch(function(err) return handleFallbackException(bufnr, err, "treesitter") end)
              :catch(function(err) return handleFallbackException(bufnr, err, "indent") end)
          end
      end,
    }
  end,

  config = function(_, opts)
    local ufo = require "ufo"
    ufo.setup(opts)
    local map = vim.keymap.set
    map("n", "zm", ufo.closeFoldsWith)
    map("n", "zM", ufo.closeAllFolds)
    map("n", "zr", ufo.openFoldsExceptKinds)
    map("n", "zR", ufo.openAllFolds)
    map("n", "zp", ufo.peekFoldedLinesUnderCursor)
  end,
}
