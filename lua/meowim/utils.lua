local Utils = {}

---Determines whether the current working directory is a git repository.
---@param cwd string?
---@return boolean
function Utils.is_git_repo(cwd)
    cwd = cwd or vim.fn.getcwd()
    return vim.fn.executable("git") == 1 and vim.uv.fs_stat(cwd .. "/.git") ~= nil
end

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
    -- Ignore hidden directories or non-repositories.
    if vim.startswith(name, ".") or not Utils.is_git_repo() then
        return
    else
        return name
    end
end

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

function Utils.session_restore()
    local name = Utils.session_get()
    if not name then
        return
    end
    require("mini.sessions").read(name, { force = false, verbose = false })
end

function Utils.session_delete()
    local name = Utils.session_get()
    if not name then
        return
    end
    require("mini.sessions").write(name, { force = true, verbose = false })
end

---Lists files with a sensible fzf picker.
---@param hidden boolean whether to show hidden files
function Utils.fzf_files(hidden)
    local cwd = vim.fn.getcwd()
    if hidden then
        require("fzf-lua").files({ cwd = cwd, hidden = true })
    else
        if Utils.is_git_repo(cwd) then
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

---Lists all todo comments of the specified keywords.
---@param keywords string[]
---@param workspace boolean
function Utils.fzf_todo(keywords, workspace)
    local opts = {
        no_esc = true,
        no_header = true,
        search = table.concat(
            vim.tbl_map(function(kw) return "\\b" .. kw .. ":\\s+.+" end, keywords),
            "|"
        ),
    }
    if workspace then
        require("fzf-lua").grep(opts)
    else
        require("fzf-lua").grep_curbuf(opts)
    end
end

---Returns Lua patterns used to highlight todo comments.
---@param keywords string[]
---@return string[]
function Utils.hipattern_todo(keywords)
    return vim.tbl_map(function(kw) return "%s?%f[%w]" .. kw .. ":%s+.+" end, keywords)
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

---Creates an one-off autocommand triggered by the `VeryLazy` event.
---@param callback fun()
function Utils.on_very_lazy(callback)
    vim.api.nvim_create_autocmd("User", {
        once = true,
        pattern = "VeryLazy",
        callback = callback,
    })
end

return Utils
