local M = {}

local astro, buf_utils = require "astrocore", require "astrocore.buffer"
local status, config = require "astroui.status", require("astroui").config.status
local hl, component, extend_tbl = status.hl, status.component, astro.extend_tbl

--- A function to build a component for automatic sidebar padding with a title.
---@param opts? table options for configuring builder settings
---@return table # The Heirline component table
function M.sidebar_title(opts)
  opts = extend_tbl({
    condition = function(self)
      self.winid = vim.api.nvim_tabpage_list_wins(0)[1]
      self.winwidth = vim.api.nvim_win_get_width(self.winid)
      self.bufnr = vim.api.nvim_win_get_buf(self.winid)
      return self.winwidth ~= vim.o.columns -- only apply to sidebars
        and not buf_utils.is_valid(self.bufnr) -- if buffer is not in tabline
    end,
    provider = function(self)
      local ft = vim.bo[self.bufnr].filetype
      local title = config.sidebar_titles and config.sidebar_titles[ft] or ft
      local padding = self.winwidth + 1 - #title
      local left = padding / 2
      return (" "):rep(left) .. title .. (" "):rep(padding - left)
    end,
    update = { "WinNew", "WinEnter", "WinResized" },
    hl = hl.get_attributes("sidebar_title", true),
  }, opts)
  return component.builder(opts)
end

return M
