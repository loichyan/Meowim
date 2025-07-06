---@type MeoSpec
return {
    "akinsho/git-conflict.nvim",
    event = "LazyFile",
    config = function()
        require("git-conflict").setup({
            default_mappings = false,
            default_commands = false,
            disable_diagnostics = true,
        })
    end,
}
