---@type MeoSpec
return {
    "mini.surround",
    event = "VeryLazy",
    config = function()
        require("mini.surround").setup({
            n_lines = 500,
            search_method = "cover_or_next",
            mappings = {
                add = "yz",
                delete = "dz",
                replace = "cz",
                find = "",
                find_left = "",
                highlight = "",
                update_n_lines = "",
            },
        })
    end,
}
