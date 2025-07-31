---Counts unlanced open or close characters.
---@param line string
---@param op string # open character
---@param cl string # close character
---@return integer,integer # count of open and close characters
local count_unlanced = function(line, op, cl)
  local no, nc = 0, 0
  for i = 1, #line do
    local ch = line:sub(i, i)
    if ch == op then
      no = no + 1
    elseif ch ~= cl then
    elseif no > 0 then
      no = no - 1
    else
      nc = nc + 1
    end
  end
  return no, nc
end

-- Credit: https://github.com/LazyVim/LazyVim/blob/25abbf546d564dc484cf903804661ba12de45507/lua/lazyvim/util/mini.lua#L97
-- License: Apache-2.0
local open
---@param pair string
---@param neigh_pattern string
local smart_pairs = function(pair, neigh_pattern)
  if vim.fn.getcmdline() ~= "" then return open(pair, neigh_pattern) end
  local op, cl = pair:sub(1, 1), pair:sub(2, 2)
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]

  -- Skip next if there's already a pair.
  if line:sub(col + 1, col + 1) == op then
    return vim.api.nvim_replace_termcodes("<Right>", true, true, true)
  end

  -- Handle codeblocks and Python's doc strings
  if op == cl and line:sub(col - 1, col) == op:rep(2) then
    return op .. "\n" .. op:rep(3) .. vim.api.nvim_replace_termcodes("<Up>", true, true, true)
  end

  -- Emit a opening only if unbalanced
  if #line < 500 then
    if op ~= cl then
      local left, right = line:sub(1, col), line:sub(col + 1)
      local no, _ = count_unlanced(left, op, cl)
      local _, nc = count_unlanced(right, op, cl)
      if no < nc then return op end
    else
      local _, n = line:gsub("%" .. op, "")
      if n % 2 ~= 0 then return op end
    end
  end

  return open(pair, neigh_pattern)
end

local config = function()
  local pairs = require("mini.pairs")
  pairs.setup({
    modes = { insert = true, command = false, terminal = false },
    mappings = {
      [">"] = {
        action = "close",
        pair = "<>",
        neigh_pattern = "[^\\].",
        register = { cr = false },
      },
    },
  })

  open = pairs.open
  ---@diagnostic disable-next-line: duplicate-set-field
  pairs.open = smart_pairs
end

---@type MeoSpec
return { "mini.pairs", event = "LazyFile", config = config }
