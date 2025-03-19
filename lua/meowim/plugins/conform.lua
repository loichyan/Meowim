---@type MeoSpec
return {
    "stevearc/conform.nvim",
    lazy = true,
    config = function()
        require("conform").setup({
            format_on_save = function(bufid)
                if not require("meowim.utils").get_toggled(bufid, "autoformat_disabled") then
                    return { lsp_fallback = true }
                end
            end,
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
                lua = { "stylua" },
            },
        })
    end,
}
