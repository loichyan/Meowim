---@type MeoSpec
return {
    "mini.sessions",
    lazy = true,
    config = function()
        require("mini.sessions").setup({
            autoread = false,
            autowrite = false,
        })

        vim.api.nvim_create_autocmd("VimLeavePre", {
            desc = "Save session on exit",
            once = true,
            callback = function()
                local name = require("meowim.utils").session_get()
                if name then
                    require("mini.sessions").write(name, { force = true, verbose = false })
                end
            end,
        })
    end,
}
