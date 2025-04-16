local Meowim = {}

local did_setup = false
function Meowim.setup()
    if did_setup then
        return
    end

    require("meowim.config.options")
    require("meowim.utils").on_very_lazy(function()
        require("meowim.config.autocommands")
        require("meowim.config.keymaps")
    end)

    did_setup = true
end

return Meowim
