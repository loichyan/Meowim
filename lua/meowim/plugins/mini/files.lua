---@type MeoSpec
return {
  "mini.files",
  event = "VeryLazy",
  config = function()
    require("mini.files").setup({
      options = { use_as_default_explorer = true },
    })
    vim.api.nvim_create_autocmd("FileType", {
      desc = "Improve motions in the explorer",
      pattern = "minifiles",
      command = "setlocal iskeyword-=_",
    })
    Meow.keyset({
      {
        "<Leader>e",
        function()
          local path = vim.api.nvim_buf_get_name(0)
          require("mini.files").open(vim.uv.fs_stat(path) and path or nil)
        end,
        desc = "Explore file directory",
      },
      {
        "<Leader>E",
        function()
          local cwd = vim.fn.getcwd()
          require("mini.files").open(require("meowim.utils").get_git_repo(cwd) or cwd)
        end,
        desc = "Explore project root",
      },
    })
  end,
}
