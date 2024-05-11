return {
  "folke/todo-comments.nvim",
  event = "User AstroFile",
  cmd = { "TodoTrouble", "TodoTelescope", "TodoLocList", "TodoQuickFix" },
  opts = {
    highlight = { multiline = true },
  },
}
