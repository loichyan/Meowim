local config = function()
    local ministl = require("mini.statusline")

    ---@type table<vim.diagnostic.Severity,integer>
    local diagnostic_counts = {}
    vim.api.nvim_create_autocmd("DiagnosticChanged", {
        desc = "Track workspace diagnostics",
        pattern = "*",
        callback = function()
            diagnostic_counts = {}
            for _, diag in ipairs(vim.diagnostic.get()) do
                diagnostic_counts[diag.severity] = (diagnostic_counts[diag.severity] or 0) + 1
            end
        end,
    })

        -- stylua: ignore
        local diff_sections = {
            { "n_ranges", "#", "diffLine"    },
            { "add",      "+", "diffAdded"   },
            { "change",   "~", "diffChanged" },
            { "delete",   "-", "diffRemoved" },
        }

        -- stylua: ignore
        local diagnostic_sections = {
            { vim.diagnostic.severity.ERROR, "E", "DiagnosticError" },
            { vim.diagnostic.severity.WARN,  "W", "DiagnosticWarn"  },
            { vim.diagnostic.severity.INFO,  "I", "DiagnosticInfo"  },
            { vim.diagnostic.severity.HINT,  "H", "DiagnosticHint"  },
        }

    -- Eviline-like statuline
    local active = function()
        local groups = {}
        local add = function(hi, string)
            if string == "" then
                return
            elseif hi == nil then
                groups[#groups] = groups[#groups] .. string
            else
                table.insert(groups, "%#" .. hi .. "#" .. string)
            end
        end

        local _, mode_hl = ministl.section_mode({})
        add(mode_hl, " %##")

        ------------------
        --- Project status
        ------------------
        local project = vim.fs.basename(vim.fn.getcwd())
        local git = vim.b.minigit_summary
        if git and git.head_name then
            local head = git.head_name
            head = head == "HEAD" and git.head:sub(1, 7) or head
            add("gitcommitBranch", " " .. project .. ":" .. head)
        else
            add("gitcommitBranch", " " .. project)
        end

        -------------------
        --- Macro Recording
        -------------------
        local macro_rec = vim.fn.reg_recording()
        if macro_rec ~= "" then
            add("Function", "󰵝 Recording @" .. macro_rec)
        end

        -------------------------
        --- Workspace diagnostics
        -------------------------
        for _, sec in ipairs(diagnostic_sections) do
            local count = diagnostic_counts[sec[1]]
            if count then
                add(sec[3], string.format("%s%d", sec[2], count))
            end
        end

        -------------
        --- Git Diffs
        -------------
        local diff = vim.b.minidiff_summary
        if diff then
            for _, sec in ipairs(diff_sections) do
                local count = diff[sec[1]]
                if count and count ~= 0 then
                    add(sec[3], string.format("%s%d", sec[2], count))
                end
            end
        end

        ------------
        --- Filename
        ------------
        local filename
        if vim.bo.buftype == "terminal" then
            filename = "%t"
        elseif ministl.is_truncated(80) then
            filename = "%t%m%r"
        else
            filename = "%f%m%r"
        end
        add("", filename)

        add(nil, "%<%=") -- End left section

        --------------
        --- File infos
        --------------
        add("", ministl.section_lsp({ trunc_width = 100 }))
        add("", ministl.section_fileinfo({ trunc_width = 120 }))

        local searchcount = ministl.section_searchcount({})
        if searchcount ~= "" then
            add("String", " Search " .. searchcount)
        end

        add("Constant", "%l|%2v")

        add(mode_hl, " %##")

        return table.concat(groups, " ")
    end

    ministl.setup({
        content = {
            active = active,
            inactive = function() end,
        },
    })
end

---@type MeoSpec
return {
    "mini.statusline",
    lazy = false,
    config = config,
}
