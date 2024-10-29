---@module "nvim-lspconfig"

---@type LazyPluginSpec
local Spec = {
  "neovim/nvim-lspconfig",
  event = "User AstroFile",
  cmd = { "LspInfo", "LspLog", "LspStart" },
  dependencies = {
    { "neoconf.nvim",                      optional = true },
    { "williamboman/mason.nvim",           config = true },
    { "williamboman/mason-lspconfig.nvim", config = true }
  },
  config = function(_, _)
    -- set border
    require("lspconfig.ui.windows").default_options.border =
        require("deltavim").get_border "float_border"
    vim.tbl_map(require("astrolsp").lsp_setup, require("astrolsp").config.servers)
    require("astrocore").exec_buffer_autocmds("FileType", { group = "lspconfig" })
    require("astrocore").event "LspSetup"
  end,
}

return Spec
