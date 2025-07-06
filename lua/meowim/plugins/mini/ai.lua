local config = function()
    local ai = require("mini.ai")
    local ts = ai.gen_spec.treesitter

    -- Select the entire buffer.
    -- Modgified from: https://github.com/LazyVim/LazyVim/blob/ec5981dfb1222c3bf246d9bcaa713d5cfa486fbd/lua/lazyvim/util/mini.lua
    local buffer = function()
        local startl, endl = 1, vim.fn.line("$")
        return {
            from = {
                line = startl,
                col = 1,
            },
            to = {
                line = endl,
                col = math.max(vim.fn.getline(endl):len(), 1),
            },
        }
    end

    require("mini.ai").setup({
        n_lines = 500,
        search_method = "cover_or_next",
        custom_textobjects = {
            c = ts({ a = "@class.outer", i = "@class.inner" }),
            f = ts({ a = "@function.outer", i = "@function.inner" }),
            o = ts({
                a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                i = { "@block.inner", "@conditional.inner", "@loop.inner" },
            }),
            g = buffer,
        },
    })
end

---@type MeoSpec
return {
    "mini.ai",
    event = "LazyFile",
    config = config,
    dependencies = { "nvim-treesitter" },
}
