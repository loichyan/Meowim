---@type MeoSpec
return {
    "mini.completion",
    event = "LazyFile",
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
                force_twostep  = "<C-Space>",
                force_fallback = "<M-Space>",
                scroll_down    = "<C-f>",
                scroll_up      = "<C-b>",
            },
        })
    end,
    dependencies = { "mini.snippets" },
}
