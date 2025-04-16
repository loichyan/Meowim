---@type MeoSpec
return {
    "mini.indentscope",
    event = "VeryLazy",
    config = function()
        local indentscope = require("mini.indentscope")
        indentscope.setup({
            symbol = "│",
            draw = {
                delay = 0,
                animation = indentscope.gen_animation.none(),
            },
            mappings = {
                object_scope = "ii",
                object_scope_with_border = "ai",
                -- configured in mini.bracked
                goto_top = "",
                goto_bottom = "",
            },
        })
    end,
}
