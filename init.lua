-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'.
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

-- Enable the experimental loader to speed up startup.
vim.loader.enable(true)

local stime = vim.loop.hrtime()
vim.api.nvim_create_autocmd("UIEnter", {
    desc = "Measure startup time",
    once = true,
    callback = function()
        _G.meowim_startup_time = vim.loop.hrtime() - stime
        pcall(require("mini.starter").refresh)
    end,
})

local disalbed_builtins = {
    "gzip",
    "netrwPlugin",
    "tarPlugin",
    "tohtml",
    "tutor",
    "zipPlugin",
}
for _, p in ipairs(disalbed_builtins) do
    vim.g["loaded_" .. p] = true
end

local deps = require("mini.deps")
deps.setup({ path = { package = pack_path } })
deps.now(function()
    deps.add("loichyan/meow.nvim")
    vim.cmd.colorscheme("onedark")
    require("meow").setup({
        specs = { imports = { "meowim.plugins" } },
    })
end)
