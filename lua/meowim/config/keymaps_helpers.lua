----------------------
--- COMMON KEYMAPS ---
----------------------

local H = {}

function H.clear_ui()
  vim.cmd("noh")
  require("quicker").close()
  require("mini.snippets").session.stop()
end

---Close other buffers.
---@param dir integer -1: close all left, 0: close all others, 1: close all right
function H.buffer_close_others(dir)
  local curr = vim.api.nvim_get_current_buf()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if curr == bufnr then
      if dir < 0 then break end
      dir = 0
    elseif vim.bo[bufnr].buflisted and dir <= 0 then
      require("mini.bufremove").delete(bufnr)
    end
  end
end

function H.zoom()
  local title = " Zoom |" .. vim.fn.expand(".") .. " "
  require("mini.misc").zoom(0, { title = title })
  -- Differentiate between zooming in and zooming out
  -- See <https://github.com/echasnovski/mini.nvim/issues/1911#issuecomment-3112985891>
  if vim.api.nvim_win_get_config(0).relative ~= "" then
    vim.wo.winhighlight = "NormalFloat:Normal"
  end
end

---@param scope "current"|"all"
function H.explorer(scope)
  local cwd, path = vim.fn.getcwd()
  if scope == "current" then
    path = vim.api.nvim_buf_get_name(0)
    path = vim.uv.fs_stat(path) and path or nil
  end
  local dir = path or require("meowim.utils").get_git_repo(cwd) or cwd
  require("mini.files").open(dir)
end

function H.gitexec(...)
  Meow.load("mini.git")
  vim.cmd.Git(...)
end

---@param key string
---@param global boolean
function H.toggle(key, global) require("meowim.utils").toggle(key, global) end

function H.toggle_conceal() vim.wo.conceallevel = 2 - vim.wo.conceallevel end

---@param scope "cursor"|"buffer"
function H.apply_hunk(scope)
  if scope == "cursor" then
    return require("mini.diff").operator("apply") .. "<Cmd>lua MiniDiff.textobject()<CR>"
  else
    require("mini.diff").do_hunks(0, "apply")
  end
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
---@param severity vim.diagnostic.Severity?
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

---@param scope "all"|"current"
---@param severity vim.diagnostic.Severity?
function H.pick_diagnostics(scope, severity)
  require("mini.pick").registry.diagnostic({
    scope = scope,
    get_opts = { severity = severity },
  })
end

---@param scope "all"|"current"
---@param tool? "rg"|"git"|"ast-grep"
function H.pick_lgrep(scope, tool)
  local globs = scope == "current" and { vim.fn.expand("%") } or nil
  if tool == "ast-grep" then
    require("mini.pick").registry.ast_grep_live({ globs = globs })
  else
    require("mini.pick").registry.grep_live({ tool = tool, globs = globs })
  end
end

---@param scope "all"|"current"
---@param tool? "rg"|"git"|"ast-grep"
function H.pick_word(scope, tool)
  local globs = scope == "current" and { vim.fn.expand("%") } or nil
  local pattern = vim.fn.expand("<cword>")
  if tool == "ast-grep" then
    require("mini.pick").registry.ast_grep({ pattern = pattern, globs = globs })
  else
    require("mini.pick").registry.grep({ tool = tool, pattern = pattern, globs = globs })
  end
end

-------------------
--- LSP KEYMAPS ---
-------------------

---Jumps to the first item if it is the only one. Otherwise, lists all items in
---quickfix.
---@param opts vim.lsp.LocationOpts.OnList
function H.list_locations(opts)
  if #opts.items > 1 then
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.fn.setqflist({}, " ", opts)
    vim.cmd("copen | cfirst")
    return
  end

  local loc = opts.items[1]
  if not loc then return end
  -- Save position in jumplist
  vim.cmd("normal! m'")
  -- Open and jump to the target position
  local buf_id = loc.bufnr or vim.fn.bufadd(loc.filename)
  vim.bo[buf_id].buflisted = true
  vim.api.nvim_win_set_buf(0, buf_id)
  vim.api.nvim_win_set_cursor(0, { loc.lnum, loc.col - 1 })
  -- Open folds under the cursor
  return vim.cmd("normal! zv")
end

---Lists only items of current buffer.
---@param opts vim.lsp.LocationOpts.OnList
function H.lsp_list_buf(opts)
  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  opts.items = vim.tbl_filter(
    function(v) return v.bufnr == bufnr or v.filename == bufname end,
    opts.items
  )
  H.list_locations(opts)
end

---Lists only the first one of items locate in consecutive lines.
---@param opts vim.lsp.LocationOpts.OnList
function H.lsp_list_unique(opts)
  local items = opts.items
  table.sort(items, function(a, b)
    if a.filename ~= b.filename then
      return a.filename < b.filename
    else
      return a.lnum < b.lnum
    end
  end)

  local new_items = { items[1] }
  for i = 2, #items do
    local curr, prev = items[i], items[i - 1]
    if curr.filename ~= prev.filename or (curr.lnum - prev.lnum) > 1 then
      table.insert(new_items, curr)
    end
  end
  opts.items = new_items
  H.list_locations(opts)
end

---@param scope "current"|"all"
function H.lsp_implementation(scope)
  vim.lsp.buf.implementation({
    on_list = scope == "current" and H.lsp_list_buf or nil,
  })
end

---@param scope "current"|"all"
function H.lsp_references(scope)
  vim.lsp.buf.references({ includeDeclaration = false }, {
    on_list = scope == "current" and H.lsp_list_buf or nil,
  })
end

function H.lsp_definition() return vim.lsp.buf.definition({ on_list = H.lsp_list_unique }) end

function H.lsp_type_definition() return vim.lsp.buf.type_definition({ on_list = H.lsp_list_unique }) end

return H
