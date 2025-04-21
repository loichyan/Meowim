local Meowim = {}

local did_setup = false
function Meowim.setup()
    if did_setup then
        return
    end

    require("meowim.config.options")
    vim.api.nvim_create_autocmd("UIEnter", {
        once = true,
        callback = function()
            require("meowim.config.keymaps")
            require("meowim.config.autocommands")
        end,
    })
    MiniDeps.later(function() require("meowim.config.polish") end)

    did_setup = true
end

return Meowim
