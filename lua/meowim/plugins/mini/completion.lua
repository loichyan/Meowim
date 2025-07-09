---@type MeoSpec
return {
    "mini.completion",
    event = "LazyFile",
    config = function()
        local completion = require("mini.completion")

        local kind_priority = { Text = 1, Snippet = 99 }
        local opts = { kind_priority = kind_priority }
        local process_items = function(items, base)
            return MiniCompletion.default_process_items(items, base, opts)
        end

        vim.o.completeopt = "menuone,noinsert,fuzzy"
        completion.setup({
            lsp_completion = {
                -- 'completefunc' conflicts with `Ctrl+U` in insert mode
                source_func = "omnifunc",
                process_items = process_items,
            },
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
        vim.lsp.config("*", { capabilities = completion.get_lsp_capabilities() })
    end,
    dependencies = { "mini.snippets" },
}
