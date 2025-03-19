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
    local name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
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
    local name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
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
