---@type MeoSpec
return {
    "akinsho/git-conflict.nvim",
    event = "VeryLazy",
    config = function()
        require("git-conflict").setup({
            default_mappings = false,
            default_commands = false,
            disable_diagnostics = false,
            -- TODO: add highlights
        })
    end,
}
