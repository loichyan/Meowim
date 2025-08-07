---@type MeoSpec
local Spec = { "mini.sessions", event = "VeryLazy" }
local M = {}

Spec.config = function()
  require("mini.sessions").setup({
    autoread = false,
    autowrite = false,
  })

  Meow.autocmd("meowim.plugins.mini.sessions", {
    {
      event = "VimLeavePre",
      desc = "Save session on exit",
      once = true,
      callback = function() M.save() end,
    },
  })
end

---Returns the name of current session if valid.
---@param cwd string?
---@return string?
function M.get_name(cwd)
  local repo = Meowim.utils.get_git_repo(cwd)
  return repo and vim.fs.basename(repo)
end

---Saves the current session.
function M.save()
  local cwd = vim.fn.getcwd()
  local name = M.get_name(cwd)
  if not name then return end
  -- Ignore an empty session.
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    -- Only consider files under current directory
    if vim.bo[b].buflisted and vim.startswith(vim.api.nvim_buf_get_name(b), cwd) then
      require("mini.sessions").write(name, { force = true, verbose = false })
      return
    end
  end
end

---Restores the current session.
function M.restore()
  local name = M.get_name()
  if not name then return end
  require("mini.sessions").read(name, { force = false, verbose = false })
end

---Deletes the current session.
function M.delete()
  local name = M.get_name()
  if not name then return end
  require("mini.sessions").write(name, { force = true, verbose = false })
end

M[1] = Spec
return M
