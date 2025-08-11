----------------------
--- COMMON KEYMAPS ---
----------------------

local H = {}

H.plugins = Meowim.plugins
H.utils = Meowim.utils

function H.clear_ui()
  vim.cmd("noh")
  require("quicker").close()
  require("mini.snippets").session.stop()
end

function H.git(...)
  Meow.load("mini.git")
  vim.cmd.Git(...)
end

function H.git_show_buffer()
  local rev
  if vim.v.count > 0 then
    rev = "HEAD~" .. vim.v.count
  else
    rev = vim.fn.expand("<cword>")
    if not H.is_git_commit(rev) then
      rev = Meowim.utils.prompt("Show revision: ")
      if rev == "" then return end
      rev = vim.fn.fnameescape(rev) -- escape to avoid expansion errors
    end
  end
  H.git("show", rev .. ":%")
end

---@param mode "prompt"|"edit"
function H.git_commit(mode)
  if mode == "edit" then
    H.git("commit")
  else
    local msg = Meowim.utils.prompt("Commit message: ")
    if msg == "" then return end
    msg = vim.fn.fnameescape(msg) -- escape to avoid expansion errors
    H.git("commit", "-m", msg)
  end
end

function H.is_git_commit(str)
  return str ~= "" and string.find(str, "^%x%x%x%x%x%x%x+$") ~= nil and string.lower(str) == str
end

-----------------------------
--- PICKERS & DIAGNOSTICS ---
-----------------------------

---@param dir "forward"|"backward"
---@param fallback string
function H.jump_quickfix(dir, fallback)
  if require("quicker").is_open() then
    require("mini.bracketed").quickfix(dir)
  else
    fallback = vim.api.nvim_replace_termcodes(fallback, true, false, true)
    vim.api.nvim_feedkeys(fallback, "n", false)
  end
end

---@param dir "forward"|"backward"|"first"|"last"
---@param severity vim.diagnostic.SeverityName?
function H.jump_diagnostic(dir, severity)
  require("mini.bracketed").diagnostic(dir, { severity = severity })
end

---@param picker string
---@param opts? table
function H.pick(picker, opts) require("mini.pick").registry[picker](opts) end

function H.pick_quickfix()
  require("quicker").close()
  require("mini.pick").registry.list({ scope = "quickfix" })
end

---@param scope "current"|"all"
---@param severity vim.diagnostic.SeverityName?
function H.pick_diagnostics(scope, severity)
  require("mini.pick").registry.diagnostic({
    scope = scope,
    get_opts = { severity = severity },
  })
end

---@param scope "current"|"all"
---@param opts? table
function H.pick_lgrep(scope, opts)
  local globs = scope == "current" and { vim.fn.expand("%") } or nil
  opts = vim.tbl_extend("force", { globs = globs }, opts or {})
  require("mini.pick").registry.grep_live(opts)
end

---@param scope "current"|"all"
---@param opts? table
function H.pick_word(scope, opts)
  local globs = scope == "current" and { vim.fn.expand("%") } or nil
  local pattern = vim.fn.expand("<cword>")
  opts = vim.tbl_extend("force", { pattern = pattern, globs = globs }, opts or {})
  require("mini.pick").registry.grep(opts)
end

-------------------
--- LSP KEYMAPS ---
-------------------

---@param scope "current"|"all"
function H.lsp_implementation(scope)
  vim.lsp.buf.implementation({
    on_list = scope == "current" and Meowim.utils.loclist_buf or nil,
  })
end

---@param scope "current"|"all"
function H.lsp_references(scope)
  vim.lsp.buf.references({ includeDeclaration = false }, {
    on_list = scope == "current" and Meowim.utils.loclist_buf or nil,
  })
end

function H.lsp_definition()
  vim.lsp.buf.definition({
    on_list = Meowim.utils.loclist_unique,
  })
end

function H.lsp_type_definition()
  vim.lsp.buf.type_definition({
    on_list = Meowim.utils.loclist_unique,
  })
end

return H
