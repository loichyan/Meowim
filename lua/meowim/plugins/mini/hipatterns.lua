---@type MeoSpec
return {
    "mini.hipatterns",
    event = "VeryLazy",
    config = function()
        local hipatterns, Utils = require("mini.hipatterns"), require("meowim.utils")
        hipatterns.setup({
            -- stylua: ignore
            highlighters = {
                hex_color = hipatterns.gen_highlighter.hex_color(),
                fixme = { pattern = Utils.hipattern_todo({ "FIXME "}), group = "MiniHipatternsFixme" },
                hack  = { pattern = Utils.hipattern_todo({ "HACK" }),  group = "MiniHipatternsHack"  },
                todo  = { pattern = Utils.hipattern_todo({ "TODO" }),  group = "MiniHipatternsTodo"  },
                note  = { pattern = Utils.hipattern_todo({ "NOTE" }),  group = "MiniHipatternsNote"  },
            },
        })
    end,
}
