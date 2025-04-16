---@type MeoSpec
return {
    "akinsho/git-conflict.nvim",
    lazy = true,
    config = function()
        require("git-conflict").setup({
            default_mappings = false,
            default_commands = false,
            disable_diagnostics = false,
            -- TODO: add highlights
        })
    end,
}
