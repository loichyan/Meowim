---@type MeoSpec
local Spec = { "mini.files", event = "VeryLazy" }
local M = {}

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
end

---Opens the explorer at the specified location.
---@param scope "buffer"|"workspace"
function M.open(scope)
  local cwd, path = vim.fn.getcwd()
  if scope == "buffer" then
    path = vim.api.nvim_buf_get_name(0)
    path = vim.uv.fs_stat(path) and path or nil
  end
  local dir = path or Meowim.utils.get_git_repo(cwd) or cwd
  require("mini.files").open(dir)
end

M[1] = Spec
return M
