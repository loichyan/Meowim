---@type MeoSpec
return {
    "mini.diff",
    lazy = true,
    config = function()
        require("mini.diff").setup({
            mappings = {
                apply = "gh",
                reset = "gH",
                textobject = "gh",
                goto_first = "[H",
                goto_prev = "[h",
                goto_next = "]h",
                goto_last = "]H",
            },
        })
    end,
}
