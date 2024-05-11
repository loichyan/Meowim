local M = {}

---Merges one or more tables into `dst`.
---@param dst table
---@param ... table
---@return table
function M.merge(dst, ...)
  for _, tbl in ipairs { ... } do
    for k, v in pairs(tbl) do
      dst[k] = v
    end
  end
  return dst
end

M.deep_merge = require("lazy.core.util").merge

---Concats one or more arrays into `dst`.
---@generic T
---@param dst T[]
---@param ... T[]
---@return T[]
function M.concat(dst, ...)
  for _, list in ipairs { ... } do
    for _, elem in ipairs(list) do
      dst[#dst + 1] = elem
    end
  end
  return dst
end

---@type table<string,table|false> cache for loaded mapping presets
local loaded_mappings = {}

---A handy function to bind mapping presets.
---@param dst table the table to be set
---@param mappings table<string,table<string,string|table>>
---@return table # return `dst`
function M.make_mappings(dst, mappings)
  local astro, unknowns = require "astrocore", {}
  for mode, maps in pairs(mappings) do
    local dst_maps = dst[mode]
    for lhs, rhs in pairs(maps) do
      if type(rhs) == "string" then
        if loaded_mappings[rhs] == nil then -- lazy load mapping presets
          local module = vim.split(rhs, ".", { plain = true })[1]
          local existed, preset = pcall(require, "deltavim.mappings." .. module)
          if existed then
            local cond = preset[1] and preset[1].cond
            if
              cond == nil
              or type(cond) == "string" and astro.is_available(cond) -- if plugin is available
              or type(cond) == "function" and cond() -- if it returns true
              or cond -- not false
            then
              for key, preset_rhs in pairs(preset) do -- insert all presets
                loaded_mappings[module .. "." .. key] = preset_rhs
              end
            else
              for key, _ in pairs(preset) do -- disable all presets
                loaded_mappings[module .. "." .. key] = false
              end
            end
          end
        end
        rhs = loaded_mappings[rhs]
        if rhs == nil then table.insert(unknowns, rhs) end
      end

      if rhs then dst_maps[lhs] = rhs end
    end
  end

  if #unknowns > 0 then -- report unknown presets
    vim.notify("unknown mapping presets:\n" .. table.concat(unknowns, "\n"), vim.log.levels.ERROR)
  end
  return dst
end

---Lists diagnostics in quickfix.
---@param bufnr integer? buffer to get diagnostics from, 0 for the current or nil for all buffers
---@param opts? vim.diagnostic.GetOpts options passed to `vim.diagnostics.get`
function M.list_diagnostics(bufnr, opts)
  local diags = vim.diagnostic.get(bufnr, opts)
  local qflist = vim.diagnostic.toqflist(diags)
  vim.fn.setqflist(qflist, " ")
  vim.cmd "botright copen"
end

---Opens Telescope to search for files in the given directory, using `git_files`
---if available, or falling back to `find_files`.
---@param cwd? string the directory to search
function M.telescope_find_files(cwd)
  cwd = cwd or vim.fn.getcwd()
  if
    vim.fn.executable "git" == 1
    -- TODO: remove vim.loop after NeoVim v0.9
    and (vim.uv or vim.loop).fs_stat(cwd .. "/.git")
  then
    require("telescope.builtin").git_files { cwd = cwd, show_untracked = true }
  else
    require("telescope.builtin").find_files { cwd = cwd }
  end
end

---@param client lsp.Client
function M.formatting_enabled(client)
  if not client.supports_method "textDocument/formatting" then return false end
  local disabled = require("astrolsp").config.formatting.disabled
  return disabled ~= true and not vim.tbl_contains(disabled, client.name)
end

return M
