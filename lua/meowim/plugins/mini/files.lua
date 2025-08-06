---@type MeoSpec
local Spec = { "mini.files", event = "VeryLazy" }

---@param scope "current"|"all"
local open = function(scope)
  local cwd, path = vim.fn.getcwd()
  if scope == "current" then
    path = vim.api.nvim_buf_get_name(0)
    path = vim.uv.fs_stat(path) and path or nil
  end
  local dir = path or require("meowim.utils").get_git_repo(cwd) or cwd
  require("mini.files").open(dir)
end

Spec.config = function()
  require("mini.files").setup({
    options = { use_as_default_explorer = true },
  })

  Meow.autocmd("meowim.plugins.mini.files", {
    {
      event = "FileType",
      pattern = "minifiles",
      desc = "Improve motions in the explorer",
      command = "setlocal iskeyword-=_",
    },
  })

  -- stylua: ignore
  Meow.keymap({
    { "<Leader>e", function() open("current") end, desc = "Explore file directory" },
    { "<Leader>E", function() open("all") end,     desc = "Explore project root"   },
  })
end

return Spec
