---@type MeoSpec
return {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    config = function()
        require("conform").setup({
            default_format_opts = {
                timeout_ms = 3000,
                async = false,
                quiet = false,
                lsp_format = "fallback",
            },
            formatters = {
                injected = { options = { ignore_errors = true } },
            },
            formatters_by_ft = {
                ["-"] = { "trim_whitespaces", lsp_format = "prefer" },
                lua = { "stylua" },
            },
        })
        vim.api.nvim_create_autocmd("BufWritePre", {
            desc = "Format on save",
            callback = function(ev)
                if not require("meowim.utils").get_toggled(ev.buf, "autoformat_disabled") then
                    require("conform").format()
                end
            end,
        })
    end,
}
