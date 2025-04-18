-- Install "mini.nvim" manually if not present.
local pack_path = vim.fn.stdpath("data") .. "/site/"
local mini_path = pack_path .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/echasnovski/mini.nvim",
        mini_path,
    })
    vim.cmd("packadd mini.nvim | helptags ALL")
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Record the startup time.
local stime = vim.loop.hrtime()
vim.api.nvim_create_autocmd("VimEnter", {
    desc = "Measure startup time",
    once = true,
    callback = function() _G.meowim_startup_time = vim.loop.hrtime() - stime end,
})

-- Enable the experimental loader and disable some useless standard plugins to
-- speed up the startup.
vim.loader.enable(true)
local disabled_builtins = {
    "gzip",
    -- "matchit",
    -- "matchparen",
    "netrwPlugin",
    "tarPlugin",
    "tohtml",
    "tutor",
    "zipPlugin",
}
for _, p in ipairs(disabled_builtins) do
    vim.g["loaded_" .. p] = true
end

-- Install the plugin manager and load our plugin specs.
local deps = require("mini.deps")
deps.setup({ path = { package = pack_path } })
deps.add({ name = "mini.nvim", checkout = "HEAD" })
deps.add({ name = "meow.nvim", checkout = "HEAD" })
deps.now(function()
    vim.cmd.colorscheme("onedark") -- Configure the preferred colorscheme.
    require("meow").setup({
        specs = { import = "meowim.plugins" },
        patch_mini = true,
        enable_snapshot = true,
    })
end)
