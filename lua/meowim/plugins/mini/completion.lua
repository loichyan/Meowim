---@type MeoSpec
return {
    "mini.completion",
    event = "VeryLazy",
    config = function()
        vim.o.completeopt = "fuzzy,menuone,noinsert,popup"
        vim.o.completeitemalign = "abbr,kind,menu"
        require("mini.completion").setup({
            window = {
                info = { border = "solid" },
                signature = { border = "solid" },
            },
            mappings = {
                force_twostep = "<C-K>",
                force_fallback = "",
                scroll_down = "<C-F>",
                scroll_up = "<C-B>",
            },
        })
    end,
    dependencies = { "mini.snippets" },
}
