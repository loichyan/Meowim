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
            -- stylua: ignore
            mappings = {
                force_twostep  = "<C-k>",
                force_fallback = "",
                scroll_down    = "<C-f>",
                scroll_up      = "<C-b>",
            },
        })
    end,
    dependencies = { "mini.snippets" },
}
