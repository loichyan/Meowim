---@type MeoSpec
local Spec = { "mini.comment", event = "LazyFile" }

Spec.config = function()
  require("mini.comment").setup({
    -- stylua: ignore
    mappings = {
      comment        = 'gc',
      comment_line   = 'gcc',
      comment_visual = 'gc',
      textobject     = 'gc',
    },
  })

  local do_cursor = function()
    return require("mini.comment").operator() .. "<Cmd>lua MiniComment.textobject()<CR>"
  end
  Meow.keymap({
    { "gcC", function() return do_cursor() end, expr = true, desc = "Toggle comment block" },
  })
end

return Spec
