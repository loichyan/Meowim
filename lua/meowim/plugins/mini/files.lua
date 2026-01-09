---@type MeoSpec
local Spec = { "mini.files", event = "VeryLazy" }
local M = { Spec }

Spec.config = function()
  require("mini.files").setup({
    options = { use_as_default_explorer = true },
  })
  Meow.autocmd("meowim.plugins.mini.files", {
    {
      event = "FileType",
      pattern = "minifiles",
      desc = "Improve motions in the explorer",
      callback = function()
        vim.opt_local.iskeyword:remove("_")
        vim.keymap.set("n", "<C-b>", "<Left>", { buffer = true })
        vim.keymap.set("n", "<C-f>", "<Right>", { buffer = true })
      end,
    },
  })
end

---Opens the explorer at the specified location.
---@param scope "buffer"|"workspace"
M.open = function(scope)
  local cwd, path = vim.fn.getcwd()
  if scope == "buffer" then
    path = vim.api.nvim_buf_get_name(0)
    local dir = vim.fn.fnamemodify(path, ":h")
    if vim.uv.fs_stat(path) then
    elseif vim.uv.fs_stat(dir) then
      path = dir
    else
      path = nil
    end
  end
  require("mini.files").open(path or Meowim.utils.get_git_repo(cwd) or cwd)
end

return M
