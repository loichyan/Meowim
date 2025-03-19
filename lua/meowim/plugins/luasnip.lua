---@type MeoSpec
return {
    "L3MON4D3/LuaSnip",
    lazy = true,
    config = function()
        require("luasnip").config.setup({
            history = true,
            delete_check_events = "TextChanged",
            region_check_events = "CursorMoved",
            update_events = "TextChanged,TextChangedI",
        })
        require("luasnip.loaders.from_vscode").lazy_load()
    end,
    dependencies = { { "rafamadriz/friendly-snippets" } },
}
