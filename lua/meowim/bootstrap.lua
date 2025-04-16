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
vim.api.nvim_create_autocmd("UIEnter", {
    desc = "Measure startup time",
    once = true,
    callback = function()
        _G.meowim_startup_time = vim.loop.hrtime() - stime
        pcall(require("mini.starter").refresh)
    end,
})

-- Enable the experimental loader and disalbe some useless standard plugins to
-- speed up the startup.
vim.loader.enable(true)
local disalbed_builtins = {
    "gzip",
    -- "matchit",
    -- "matchparen",
    "netrwPlugin",
    "tarPlugin",
    "tohtml",
    "tutor",
    "zipPlugin",
}
for _, p in ipairs(disalbed_builtins) do
    vim.g["loaded_" .. p] = true
end

-- Install the plugin manager and load our plugin specs.
local deps = require("mini.deps")
deps.setup({ path = { package = pack_path } })
deps.now(function()
    deps.add("loichyan/meow.nvim")
    vim.cmd.colorscheme("onedark") -- Configure the preferred colorscheme.
    require("meow").setup({
        specs = { imports = { "meowim.plugins" } },
    })
end)
