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

---@param mode "prompt"|"edit"|"amend"
function H.git_commit(mode)
  if mode == "edit" then
    H.git("commit")
  elseif mode == "amend" then
    local msg = Meowim.utils.prompt("Edit message? (y/N) ", { mode = "char" })
    msg = msg:lower()
    if msg == "y" then
      H.git("commit", "--amend")
    elseif msg == "n" or msg == "\r" then
      H.git("commit", "--amend", "--no-edit")
    end
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
  local float = not vim.diagnostic.config().virtual_lines
  require("mini.bracketed").diagnostic(dir, { float = float, severity = severity })
end

---@param picker string
function H.pick(picker, local_opts) require("mini.pick").registry[picker](local_opts) end

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
function H.pick_lgrep(scope, grep_opts)
  local globs = scope == "current" and { vim.fn.expand("%") } or nil
  grep_opts = vim.tbl_extend("force", { globs = globs }, grep_opts or {})
  require("mini.pick").registry.grep_live(grep_opts)
end

---@param scope "current"|"all"
function H.pick_word(scope, grep_opts)
  local globs = scope == "current" and { vim.fn.expand("%") } or nil
  local pattern = vim.fn.expand("<cword>")
  pattern = pattern == "" and pattern or Meowim.utils.prompt("Search word: ")

  local default_grep_opts = { pattern = pattern, globs = globs, tool = "rg" }
  grep_opts = vim.tbl_extend("force", default_grep_opts, grep_opts or {})
  if grep_opts.tool ~= "ast-grep" then grep_opts.pattern = "\\b" .. grep_opts.pattern .. "\\b" end

  local name = string.format("Grep (%s | %s)", grep_opts.tool, pattern)
  local opts = { source = { name = name } }
  require("mini.pick").registry.grep(grep_opts, opts)
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
