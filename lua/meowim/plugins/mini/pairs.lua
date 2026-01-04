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
H.smart_pairs = function(open, pair, neigh_pattern)
  if vim.fn.getcmdline() ~= "" then return open(pair, neigh_pattern) end

  local op, cl = pair:sub(1, 1), pair:sub(2, 2)
  local line, cur = vim.api.nvim_get_current_line(), vim.api.nvim_win_get_cursor(0)
  local row, col = cur[1], cur[2]

  -- Handle triple quotes
  if op == cl and line:sub(col - 1, col) == op:rep(2) then
    return op .. "\n" .. op:rep(3) .. vim.api.nvim_replace_termcodes("<Up>", true, true, true)
  end

  -- Disable quotes in string literals
  if op == cl then
    local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, row - 1, math.max(col - 1, 0))
    if ok and #captures == 1 and captures[1].capture == "string" then return op end
  end

  -- Emit only an opening if unbalanced
  if line:len() < 500 then
    if op ~= cl then -- pairs
      local left, right = line:sub(1, col), line:sub(col + 1)
      local no, _ = H.count_unlanced(left, op, cl)
      local _, nc = H.count_unlanced(right, op, cl)
      if no < nc then return op end
    else -- quotes
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
H.count_unlanced = function(line, op, cl)
  local no, nc = 0, 0
  for i = 1, #line do
    local ch = line:sub(i, i)
    if ch == op then
      -- Found an unbalanced open character
      no = no + 1
    elseif ch ~= cl then
      -- Ignore non-pairing characters
    elseif no > 0 then
      -- Found a balanced pair
      no = no - 1
    else
      -- Found an unbalanced close character
      nc = nc + 1
    end
  end
  return no, nc
end

return Spec
