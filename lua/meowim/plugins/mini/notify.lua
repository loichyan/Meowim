---@type MeoSpec
return {
    "mini.notify",
    lazy = false,
    priority = 95,
    config = function()
        local notify = require("mini.notify")
        notify.setup()
        vim.notify = notify.make_notify()
        -- TODO: find notifications
    end,
}
