---@type MeoSpec
return {
    "mini.operators",
    event = "VeryLazy",
    config = function()
        -- stylua: ignore
        require("mini.operators").setup({
            evaluate = { prefix = "g=" },
            exchange = { prefix = "gx" },
            multiply = { prefix = "gm" },
            replace  = { prefix = "gr" },
            sort     = { prefix = "gs" },
        })
    end,
}
