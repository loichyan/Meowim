local config = function()
  ---@diagnostic disable-next-line:missing-fields
  require("nvim-treesitter.configs").setup({
    sync_install = false,
    ensure_installed = {
      "bash",
      "c",
      "diff",
      "html",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "query",
      "vim",
      "vimdoc",
    },
    auto_install = true,
    highlight = { enable = true, additional_vim_regex_highlighting = false },
    incremental_selection = { enable = false },
    indent = { enable = true },
    textobjects = {
      -- stylua: ignore
      move = {
        enable = true,
        goto_next_start     = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
        goto_next_end       = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
        goto_previous_end   = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
      },
    },
  })
end

---@type MeoSpec
return {
  "nvim-treesitter/nvim-treesitter",
  checkout = "master",
  build = function() vim.cmd("TSUpdate") end,
  event = "VeryLazy",
  config = config,
}
