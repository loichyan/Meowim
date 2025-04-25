local Meowim = {}

local did_setup = false
function Meowim.setup()
    if did_setup then
        return
    end

    require("meowim.config.options")
    -- Set up keymaps and autocommands once we enter the UI.
    vim.api.nvim_create_autocmd("UIEnter", {
        once = true,
        desc = "meowim.config",
        callback = function()
            require("meowim.config.keymaps")
            require("meowim.config.autocommands")
            require("meowim.config.polish")
        end,
    })
    -- See <https://github.com/LazyVim/LazyVim/blob/ec5981dfb1222c3bf246d9bcaa713d5cfa486fbd/lua/lazyvim/util/plugin.lua#L10>
    Meow.manager.event_aliases["LazyFile"] = { "BufReadPre", "BufNewFile" }

    did_setup = true
end

return Meowim
