local Utils = {}

---Close other buffers.
---@param dir integer -1: close all left, 0: close all others, 1: close all right
function Utils.buffer_close_others(dir)
    local curr = vim.api.nvim_get_current_buf()
    for _, bufid in ipairs(vim.api.nvim_list_bufs()) do
        if curr == bufid then
            if dir < 0 then
                break
            end
            dir = 0
        elseif vim.bo[bufid].buflisted and dir <= 0 then
            require("mini.bufremove").delete(bufid)
        end
    end
end

---Returns the name of current session if valid.
---@return string?
function Utils.session_get()
    local name = vim.fs.basename(vim.fn.getcwd())
    -- Ignore a hidden directory.
    if vim.startswith(name, ".") then
        return
    end
    -- Ignore an empty session.
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[b].buflisted and vim.api.nvim_buf_get_name(b) ~= "" then
            return name
        end
    end
end

function Utils.session_restore()
    local name = vim.fs.basename(vim.fn.getcwd())
    if not name then
        return
    end
    require("mini.sessions").read(name, { force = false, verbose = false })
end

---Lists files with a sensible fzf picker.
---@param hidden boolean whether to show hidden files
function Utils.fzf_files(hidden)
    local cwd = vim.fn.getcwd()
    if hidden then
        require("fzf-lua").files({ cwd = cwd, hidden = true })
    else
        if vim.fn.executable("git") == 1 and vim.uv.fs_stat(cwd .. "/.git") then
            require("fzf-lua").git_files({
                -- Show untracked files.
                cmd = "git ls-files --exclude-standard --cached --modified --others --deduplicate",
                cwd = cwd,
                hidden = false,
            })
        else
            require("fzf-lua").files({ cwd = cwd, hidden = false })
        end
    end
end

---Creates an automatically cached colorscheme:
---  1. Create `colors/<name>.lua` in your configuration directory.
---  2. Call `cached_colorscheme(<name>, <set up your colorscheme>)`.
---@param name string
---@param setup fun()
function Utils.cached_colorscheme(name, setup)
    local curr_path = vim.api.nvim_get_runtime_file("/colors/" .. name .. ".lua", false)[1]
    if not curr_path then
        error("cannot find the specified colorscheme: " .. name)
    end
    local curr_ts = assert(vim.loop.fs_stat(curr_path)).mtime.nsec

    local cache_dir = vim.fn.stdpath("cache") .. "/colors/"
    local cache_path = cache_dir .. name .. ".lua"
    local cache_ts_path = cache_dir .. name .. ".timestamp"

    local _, cache_ts_file = pcall(io.open, cache_ts_path, "r")
    if cache_ts_file then
        local cache_ts = cache_ts_file:read("*n")
        if cache_ts == curr_ts then
            -- Cache is the latest, load it.
            dofile(cache_path)
            return
        end
    end

    -- Cache is not found or expired, compile the colorscheme.
    setup()
    require("mini.colors").get_colorscheme():write({
        compress = true,
        directory = cache_dir,
        name = name,
    })
    assert(io.open(cache_ts_path, "w"):write(curr_ts))
    local compiled = string.dump(assert(loadfile(cache_path)), true)
    assert(io.open(cache_path, "wb"):write(compiled))
end

---Returns the state of a toggler of current buffer.
---@param bufid integer
---@param key string
function Utils.get_toggled(bufid, key)
    local val = vim.b[bufid][key]
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
            local bufid = vim.api.nvim_get_current_buf()
            vim.b[bufid][key] = not Utils.get_toggled(bufid, key)
        end
    end
end

return Utils
