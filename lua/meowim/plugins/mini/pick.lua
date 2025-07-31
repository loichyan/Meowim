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
  MiniPick.default_choose_marked(MiniPick.get_picker_matches().all, { list_type = "quickfix" })
  vim.schedule(function() vim.cmd("cfirst") end)
  return true
end

local config = function()
  local pick = require("mini.pick")
  pick.setup({
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
    pick.registry[name] = picker
  end
end

---@type MeoSpec
return {
  "mini.pick",
  event = "VeryLazy",
  init = function()
    -- Replace vim.ui.select with mini's picker.
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.select = function(...) require("mini.pick").ui_select(...) end
  end,
  config = config,
}
