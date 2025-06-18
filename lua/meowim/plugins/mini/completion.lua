---@type MeoSpec
return {
    "mini.completion",
    event = "LazyFile",
    config = function()
        vim.o.completeopt = "menuone,noinsert,fuzzy"
        local completion = require("mini.completion")
        completion.setup({
            -- "omnifunc" is required if we set `scroll_up` to <C-u>
            lsp_completion = { source_func = "omnifunc" },
            window = {
                info = { border = "solid" },
                signature = { border = "solid" },
            },
            -- stylua: ignore
            mappings = {
                force_twostep  = "<C-Space>",
                force_fallback = "<M-Space>",
                scroll_down    = "<C-d>",
                scroll_up      = "<C-u>",
            },
        })
        vim.lsp.config("*", { capabilities = completion.get_lsp_capabilities() })

        vim.keymap.set("i", "<C-d>", function()
            if vim.fn.pumvisible() == 0 or not MiniCompletion.scroll("down") then
                -- Ported from vim-rsi
                return (vim.fn.col(".") > #vim.fn.getline(".")) and "<C-d>" or "<Del>"
            end
        end, { expr = true, desc = "Scroll signature/info down" })
        vim.keymap.set("i", "<C-u>", function()
            if vim.fn.pumvisible() == 0 or not MiniCompletion.scroll("up") then
                return "<C-u>"
            end
        end, { expr = true, desc = "Scroll signature/info up" })
    end,
    dependencies = { "mini.snippets" },
}
