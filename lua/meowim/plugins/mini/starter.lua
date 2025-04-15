---@type MeoSpec
return {
    "mini.starter",
    lazy = false,
    config = function()
        local starter = require("mini.starter")
        starter.setup({
            evaluate_single = true,
            -- stylua: ignore
            items = {
                { section = "Actions", name = "New Buffer",      action = "enew"                                                   },
                { section = "Actions", name = "Restore Session", action = function() require("meowim.utils").session_restore() end },
                { section = "Actions", name = "Files Picker",    action = function() require("meowim.utils").fzf_files(false) end  },
                { section = "Actions", name = "Marks Picker",    action = function() require("fzf-lua").marks() end                },
                { section = "Actions", name = "Oldfiles Picker", action = function() require("fzf-lua").oldfiles() end             },
                { section = "Actions", name = "Quit Neovim",     action = "qall"                                                   },
                starter.sections.sessions(5, true),
            },
            content_hooks = {
                starter.gen_hook.adding_bullet(),
                starter.gen_hook.indexing("all", { "Actions" }),
                starter.gen_hook.aligning("center", "center"),
            },
            footer = function()
                local time = _G.meowim_startup_time or 0
                local total = 0
                local loaded = 0
                for _, p in ipairs(require("meow").manager:plugins()) do
                    if
                        not p:is_disabled()
                        and (not p:is_shadow() or (vim.startswith(p.name, "mini.")))
                    then
                        total = total + 1
                        if not p:is_lazy() then
                            loaded = loaded + 1
                        end
                    end
                end
                return ("Loaded %d/%d plugins  in %.2fms"):format(loaded, total, time / 1000000)
            end,
        })
    end,
    dependencies = { "mini.sessions", "mini.tabline", "mini.statusline" },
}
