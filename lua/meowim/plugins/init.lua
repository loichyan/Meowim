require("meowim").setup()

---@type MeoSpecs
return {
    {
        "loichyan/Meowim",
        shadow = true,
        lazy = false,
        priority = 999,
    },
    {
        "echasnovski/mini.nvim",
        lazy = false,
        import = "meowim.plugins.mini",
    },
}
