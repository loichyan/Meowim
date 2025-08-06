---@type MeoSpec
local Spec = { "mini.pick", event = "VeryLazy" }

---Shows preview at center.
local center_preview = function(bufnr, item, opts)
  return MiniPick.default_preview(
    bufnr,
    item,
    vim.tbl_extend("force", { line_position = "center" }, opts or {})
  )
end

---Shows all selected items in the quickfix list.
local open_quickfix = function()
  local matches = MiniPick.get_picker_matches()
  if not matches then return end
  local marked, all = matches.marked, matches.all
  local items = (marked and #marked > 0) and marked or all
  MiniPick.default_choose_marked(items, { list_type = "quickfix" })
  vim.schedule(function() vim.cmd("cfirst") end)
  return true
end

Spec.config = function()
  local minipick = require("mini.pick")
  minipick.setup({
    -- stylua: ignore
    mappings = {
      choose        = "<CR>",
      choose_marked = "<M-CR>",
      refine        = "<C-Space>",
      refine_marked = "<M-Space>",

      scroll_left   = "<C-h>",
      scroll_right  = "<C-l>",
      scroll_down   = "<C-f>",
      scroll_up     = "<C-b>",

      stop          = "<Esc>",

      open_quickfix = { char = "<C-q>", func = open_quickfix },
    },
    source = {
      preview = center_preview,
    },
  })

  -- Register extra pickers.
  Meow.load("mini.extra")
  for name, picker in pairs(require("meowim.plugins.mini.extra.pickers")) do
    minipick.registry[name] = picker
  end

  -- Replace vim.ui.select with mini's picker.
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.select = function(...) minipick.ui_select(...) end
end

return Spec
