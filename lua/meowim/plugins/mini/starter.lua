local config = function()
    local prev_laststatus
    local hide_statusline = function(content)
        if not prev_laststatus then
            prev_laststatus = vim.o.laststatus
            vim.o.laststatus = 0
        end
        return content
    end
    vim.api.nvim_create_autocmd("BufWinEnter", {
        desc = "Restore statusline",
        callback = function()
            if prev_laststatus and vim.bo.filetype ~= "ministarter" then
                vim.o.laststatus = prev_laststatus
                prev_laststatus = nil
            end
        end,
    })

    local starter = require("mini.starter")
    starter.setup({
        evaluate_single = true,
        -- stylua: ignore
        items = {
            { section = "Actions", name = "New Buffer",      action = "enew"                                                           },
            { section = "Actions", name = "Restore Session", action = function() require("meowim.utils").session_restore() end         },
            { section = "Actions", name = "Files Picker",    action = function() require("meowim.utils").fzf_files(false) end          },
            { section = "Actions", name = "Grep",            action = function() require("fzf-lua").live_grep({ hidden = false }) end  },
            { section = "Actions", name = "Marks Picker",    action = function() require("fzf-lua").marks() end                        },
            { section = "Actions", name = "Oldfiles Picker", action = function() require("fzf-lua").oldfiles() end                     },
            { section = "Actions", name = "Quit Neovim",     action = "qall"                                                           },
            starter.sections.sessions(5, true),
        },
        footer = function()
            local time = _G.meowim_startup_time or 0
            local total = 0
            local loaded = 0
            for _, p in ipairs(Meow.manager:plugins()) do
                if p:is_enabled() then
                    total = total + 1
                    if not p:is_lazy() then
                        loaded = loaded + 1
                    end
                end
            end
            return ("Loaded %d/%d plugins  in %.2fms"):format(loaded, total, time / 1000000)
        end,
        content_hooks = {
            hide_statusline,
            starter.gen_hook.adding_bullet(),
            starter.gen_hook.indexing("all", { "Actions" }),
            starter.gen_hook.aligning("center", "center"),
        },
    })
end

---@type MeoSpec
return {
    "mini.starter",
    lazy = false,
    config = config,
    dependencies = { "mini.sessions" },
}
