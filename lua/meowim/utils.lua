local Utils = {}

---Wraps the given function with a new one.
---@param old function
---@param new function
function Utils.wrap_fn(old, new)
  return function(...) return new(old, ...) end
end

---Asks user for a input.
---@param opts? {mode:"str"|"char"}
function Utils.prompt(prompt, opts)
  local mode = (opts or {}).mode or "str"

  local ok, msg
  if mode == "str" then
    vim.cmd("echohl Question")
    ok, msg = pcall(vim.fn.input, prompt)
    vim.cmd("echohl None | redraw")
  else
    vim.schedule(function()
      vim.cmd("echo '' | redraw")
      vim.api.nvim_echo({ { prompt, "Question" } }, false, {})
    end)
    ok, msg = pcall(vim.fn.getcharstr)
    vim.cmd("echo '' | redraw")
  end

  return ok and msg or ""
end

---Closes current window if possible, otherwise current buffer.
function Utils.try_close()
  if not pcall(vim.cmd.close) then require("mini.bufremove").delete() end
end

---Returns the top level path if the specified directory is inside a repository.
---@param cwd string?
---@return string?
function Utils.get_git_repo(cwd)
  cwd = cwd or vim.fn.getcwd()
  local ok, p = pcall(vim.system, { "git", "rev-parse", "--show-toplevel" }, { cwd = cwd })
  local rev = ok and vim.trim(p:wait().stdout)
  return rev and rev ~= "" and rev or nil
end

---Returns the state of a toggler of current buffer.
---@param bufnr integer
---@param key string
function Utils.is_toggle_on(bufnr, key)
  local val = vim.b[bufnr][key]
  if val == nil then val = vim.g[key] end
  return val == true
end

---Toggles the specified option, returning the newly set state. The default is
---always false.
---@param key string
---@param scope? "buffer"|"global"
---@return boolean
function Utils.toggle(key, scope)
  if scope == "global" then
    vim.g[key] = not vim.g[key]
    return vim.g[key]
  else
    local bufnr = vim.api.nvim_get_current_buf()
    vim.b[bufnr][key] = not Utils.is_toggle_on(bufnr, key)
    return vim.b[bufnr][key]
  end
end

---Jumps to the first item if it is the only one. Otherwise, lists all items in
---quickfix.
---@param opts vim.lsp.LocationOpts.OnList
function Utils.loclist_or_jump(opts)
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
function Utils.loclist_buf(opts)
  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  opts.items = vim.tbl_filter(
    function(v) return v.bufnr == bufnr or v.filename == bufname end,
    opts.items
  )
  Utils.loclist_or_jump(opts)
end

---Lists only the first one of items locate in consecutive lines.
---@param opts vim.lsp.LocationOpts.OnList
function Utils.loclist_unique(opts)
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
  Utils.loclist_or_jump(opts)
end

---@class meowim.utils.cached_colorscheme.options
---The name to identify this colorscheme.
---@field name string
---A token to identify the latest cache.
---@field cache_token? string
---A list of runtime files used to determine whether to update the cache.
---@field watch_paths? string[]
---The function used to setup the colorscheme. An optional colorscheme object
---obtained from MiniColors can be returned to generate highlight groups.
---@field setup fun():table?

---@param opts meowim.utils.cached_colorscheme.options
function Utils.cached_colorscheme(opts)
  local cache_dir = vim.fn.stdpath("cache") .. "/colors/"
  local cache_path = cache_dir .. opts.name .. ".lua"
  local cache_token_path = cache_dir .. opts.name .. "_cache"

  local cache_token = opts.cache_token or ""
  if opts.watch_paths then
    for _, path in ipairs(opts.watch_paths) do
      local realpath = vim.api.nvim_get_runtime_file(path, false)[1]
      if not realpath then error("cannot find runtime file: " .. path) end
      local timestamp = assert(vim.uv.fs_stat(realpath)).mtime.nsec
      cache_token = cache_token .. " " .. timestamp
    end
  end

  -- Try to load from cache.
  if cache_token ~= "" then
    local cache_token_file, _ = io.open(cache_token_path, "r")
    if cache_token_file and cache_token_file:read("*a") == cache_token then
      dofile(cache_path)
      return
    end
  end

  -- Cache not found or expired, compile the colorscheme.
  -- 1) Setup mini.base16 and apply customizations.
  local colors = opts.setup() or require("mini.colors").get_colorscheme()
  -- Defer cache rebuilding to speed up startup
  if cache_token ~= "" then
    vim.schedule(function()
      -- 2) Write the compiled colorscheme into the cached module.
      colors:write({ compress = true, directory = cache_dir, name = opts.name })
      -- 3) Save cache tokens
      assert(assert(io.open(cache_token_path, "w")):write(cache_token))
    end)
  end
end

---Increases the lightness of the specified color.
---@param color string
---@param delta number
---@return string
function Utils.lighten(color, delta)
  return require("mini.colors").modify_channel(color, "lightness", function(x)
    if math.abs(delta) < 1 then
      return x + delta * x
    else
      return x + delta
    end
  end) --[[@as string]]
end

return Utils
