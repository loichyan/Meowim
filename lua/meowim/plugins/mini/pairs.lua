---@type MeoSpec
local Spec = { "mini.pairs", event = "LazyFile" }
local H = {}

Spec.config = function()
  local minipairs = require("mini.pairs")
  minipairs.setup({
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

  ---@diagnostic disable-next-line: duplicate-set-field
  minipairs.open = Meowim.utils.wrap_fn(minipairs.open, H.smart_pairs)

  Meow.autocmd("meowim.plugins.mini.pairs", {
    {
      event = "FileType",
      pattern = "rust",
      desc = "Disable annoying pairs for certain languages",
      callback = function(ev) vim.keymap.set("i", "'", "'", { buffer = ev.buf }) end,
    },
  })
end

-- Credit: https://github.com/LazyVim/LazyVim/blob/25abbf546d564dc484cf903804661ba12de45507/lua/lazyvim/util/mini.lua#L97
-- License: Apache-2.0
---@param open function
---@param pair string
---@param neigh_pattern string
function H.smart_pairs(open, pair, neigh_pattern)
  if vim.fn.getcmdline() ~= "" then return open(pair, neigh_pattern) end

  local op, cl = pair:sub(1, 1), pair:sub(2, 2)
  local line, cur = vim.api.nvim_get_current_line(), vim.api.nvim_win_get_cursor(0)
  local row, col = cur[1], cur[2]

  -- Handle codeblocks and Python's doc strings
  if op == cl and line:sub(col - 1, col) == op:rep(2) then
    return op .. "\n" .. op:rep(3) .. vim.api.nvim_replace_termcodes("<Up>", true, true, true)
  end

  -- Disable pairing in string nodes
  local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, row - 1, math.max(col - 1, 0))
  for _, capture in ipairs(ok and captures or {}) do
    if capture.capture == "string" then return op end
  end

  -- Emit a opening only if unbalanced
  if #line < 500 then
    if op ~= cl then
      local left, right = line:sub(1, col), line:sub(col + 1)
      local no, _ = H.count_unlanced(left, op, cl)
      local _, nc = H.count_unlanced(right, op, cl)
      if no < nc then return op end
    else
      local _, n = line:gsub("%" .. op, "")
      if n % 2 ~= 0 then return op end
    end
  end

  return open(pair, neigh_pattern)
end

---Counts unlanced open or close characters.
---@param line string
---@param op string # open character
---@param cl string # close character
---@return integer,integer # count of open and close characters
function H.count_unlanced(line, op, cl)
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

return Spec
