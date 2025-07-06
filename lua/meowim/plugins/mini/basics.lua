---@type MeoSpec
return {
    "mini.basics",
    lazy = false,
    priority = 90,
    config = function()
        require("mini.basics").setup({
            options = {
                basic = true,
                extra_ui = true,
                win_borders = "rounded",
            },
            mappings = {
                basic = true,
                option_toggle_prefix = "<LocalLeader>",
            },
            autocommands = {
                basic = true,
            },
            silent = true,
        })
    end,
}
