local Utils = {}

---Returns the top level path if the specified directory is inside a repository.
---@param cwd string?
---@return string?
function Utils.get_git_repo(cwd)
    cwd = cwd or vim.fn.getcwd()
    local ok, p = pcall(vim.system, { "git", "rev-parse", "--show-toplevel" }, { cwd = cwd })
    local rev = ok and vim.trim(p:wait().stdout)
    return rev and rev ~= "" and rev or nil
end

---Returns the name of current session if valid.
---@return string?
function Utils.session_get()
    local repo = Utils.get_git_repo()
    return repo and vim.fs.basename(repo)
end

---Saves the current session.
function Utils.session_save()
    local name = require("meowim.utils").session_get()
    if not name then
        return
    end
    -- Ignore an empty session.
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[b].buflisted and vim.api.nvim_buf_get_name(b) ~= "" then
            require("mini.sessions").write(name, { force = true, verbose = false })
            return
        end
    end
end

---Restores the current session.
function Utils.session_restore()
    local name = Utils.session_get()
    if not name then
        return
    end
    require("mini.sessions").read(name, { force = false, verbose = false })
end

---Deletes the current session.
function Utils.session_delete()
    local name = Utils.session_get()
    if not name then
        return
    end
    require("mini.sessions").write(name, { force = true, verbose = false })
end

---Lists files with a sensible picker.
---@param hidden boolean whether to show hidden files
function Utils.pick_files(hidden)
    local cwd = vim.fn.getcwd()
    local command
    if hidden then
        command = { "rg", "--files", "--no-follow", "--color=never", "--no-ignore" }
        -- MiniExtra.pickers.git_files(local_opts, opts)
    elseif Utils.get_git_repo(cwd) == cwd then
        -- stylua: ignore
        command = { "git", "ls-files", "--exclude-standard", "--cached", "--modified", "--others", "--deduplicate" }
    else
        command = { "rg", "--files", "--no-follow", "--color=never" }
    end
    local pick = require("mini.pick")
    pick.builtin.cli({ command = command }, {
        source = {
            name = "Files",
            cwd = cwd,
            show = (vim.b.minipick_config or pick.config).source.show
                or function(b, i, q) pick.default_show(b, i, q, { show_icons = true }) end,
        },
    })
end

---Lists all todo comments of the specified keywords.
---@param scope "current"|"all"
---@param keywords string[]
function Utils.pick_todo(scope, keywords)
    require("mini.pick").builtin.grep({
        pattern = "\\b(" .. table.concat(keywords, "|") .. ")(\\(.*\\))?:\\s+.+",
        globs = scope == "current" and { vim.fn.expand("%") } or nil,
    }, {
        source = { name = table.concat(keywords, "|") },
    })
end

---Returns Lua patterns used to highlight todo comments.
---@param keywords string[]
---@return string[]
function Utils.hipattern_todo(keywords)
    local patterns = {}
    for _, kw in ipairs(keywords) do
        table.insert(patterns, "%s?%f[%w]" .. kw .. ":%s+.+") -- KEYWORD: something
        table.insert(patterns, "%s?%f[%w]" .. kw .. "%(.*%):%s+.+") -- KEYWORD(@somebody): something
    end
    return patterns
end

---Returns the state of a toggler of current buffer.
---@param bufnr integer
---@param key string
function Utils.get_toggled(bufnr, key)
    local val = vim.b[bufnr][key]
    if val == nil then
        val = vim.g[key]
    end
    return val == true
end

---Creates a toggler used to toggle locally or globally configured option. The
---default of the specified option is always false.
---@param key string
---@param global boolean
---@return fun()
function Utils.create_toggler(key, global)
    if global then
        return function() vim.g[key] = not vim.g[key] end
    else
        return function()
            local bufnr = vim.api.nvim_get_current_buf()
            vim.b[bufnr][key] = not Utils.get_toggled(bufnr, key)
        end
    end
end

---@class meowim.utils.cached_colorscheme.options
---The name to identify this colorscheme.
---@field name string
---A list of runtime files used to determine whether to update the cache.
---@field watch_paths string[]
---The function used to set up the colorscheme. An optional colorscheme object
---obtained from MiniColors can be returned to generate highlight groups.
---@field setup fun():table?

---@param opts meowim.utils.cached_colorscheme.options
function Utils.cached_colorscheme(opts)
    local cache_dir = vim.fn.stdpath("cache") .. "/colors/"
    local cache_path = cache_dir .. opts.name .. ".lua"
    local cache_ts_path = cache_dir .. opts.name .. "_cache"

    local input_ts = vim.tbl_map(function(path)
        local realpath = vim.api.nvim_get_runtime_file(path, false)[1]
        if not realpath then
            error("cannot find runtime file: " .. path)
        end
        return assert(vim.uv.fs_stat(realpath)).mtime.nsec
    end, opts.watch_paths)

    -- Try to load from cache.
    local _, cache_ts_file = pcall(io.open, cache_ts_path, "r")
    if cache_ts_file then
        for _, ts in ipairs(input_ts) do
            if cache_ts_file:read("*n") ~= ts then
                goto expired
            end
        end
        dofile(cache_path)
        return
    end
    ::expired::

    -- Cache not found or expired, compile the colorscheme.
    -- 1) Setup mini.base16 and apply customizations.
    local colors = opts.setup() or require("mini.colors").get_colorscheme()
    -- 2) Dump the highlight groups.
    colors:write({ compress = true, directory = cache_dir, name = opts.name })
    -- 3) Re-compile the colorscheme to bytecodes.
    local bytes = string.dump(assert(loadfile(cache_path)), true)
    assert(io.open(cache_path, "w"):write(bytes))
    -- 4) Save timestamps.
    cache_ts_file = assert(io.open(cache_ts_path, "w"))
    vim.print(input_ts)
    for _, ts in ipairs(input_ts) do
        assert(cache_ts_file:write(ts, "\n"))
    end
end

return Utils
