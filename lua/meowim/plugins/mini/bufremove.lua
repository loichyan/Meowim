---@type MeoSpec
local Spec = { 'mini.bufremove', lazy = true }
local M = { Spec }

Spec.config = function() require('mini.bufremove').setup() end

---Close other buffers.
---@param dir 'left'|'right'|'all'
M.close_others = function(dir)
  local idir = dir == 'left' and -1 or dir == 'right' and 1 or 0
  local curr = vim.api.nvim_get_current_buf()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if curr == bufnr then
      if idir < 0 then break end
      idir = 0
    elseif vim.bo[bufnr].buflisted and idir <= 0 then
      require('mini.bufremove').delete(bufnr)
    end
  end
end

return M
