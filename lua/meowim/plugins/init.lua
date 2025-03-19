---@type MeoSpecs
return {
    { "echasnovski/mini.nvim", lazy = false, priority = 0 },
    {
        "Meowim:autocommands",
        shadow = true,
        lazy = false,
        config = function() require("meowim.config.autocommands") end,
    },
    {
        "Meowim:options",
        shadow = true,
        lazy = false,
        config = function() require("meowim.config.options") end,
    },
    {
        "Meowim:keymaps",
        shadow = true,
        lazy = true,
        config = function() require("meowim.config.keymaps") end,
    },
}
