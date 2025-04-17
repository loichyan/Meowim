---@type MeoSpec
return {
    "mini.misc",
    event = "VeryLazy",
    config = function()
        local misc = require("mini.misc")
        misc.setup({ make_global = { "put", "put_text", "bench_time", "stat_summary" } })
        misc.setup_auto_root()
        misc.setup_restore_cursor()
        Meow.keyset({
            {
                "<Leader>m",
                function() require("mini.misc").zoom() end,
                desc = "Zoom current buffer",
            },
        })
    end,
}
