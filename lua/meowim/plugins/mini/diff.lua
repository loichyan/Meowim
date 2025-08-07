---@type MeoSpec
local Spec = { "mini.diff", event = "LazyFile" }
local M = {}

Spec.config = function()
  require("mini.diff").setup({
      -- stylua: ignore
      mappings = {
        apply      = "gh",
        reset      = "gH",
        textobject = "gh",
        goto_first = "[G",
        goto_prev  = "[g",
        goto_next  = "]g",
        goto_last  = "]G",
      },
  })
end

---Stages hunks at cursor or in the entire buffer.
---@param scope "cursor"|"buffer"
function M.stage_hunk(scope)
  if scope == "cursor" then
    return require("mini.diff").operator("apply") .. "<Cmd>lua MiniDiff.textobject()<CR>"
  else
    require("mini.diff").do_hunks(0, "apply")
  end
end

M[1] = Spec
return M
