-- Bootstrap begin
local start_time = vim.uv.hrtime()

-- Enable the experimental loader for faster `require`s.
vim.loader.enable(true)

-- Install mini.nvim if not present.
local pack_path = vim.fn.stdpath("data") .. "/site/"
local mini_path = pack_path .. "pack/deps/start/mini.nvim"
if not vim.uv.fs_stat(mini_path) then
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

-- Setup the plugin installer.
local deps = require("mini.deps")
deps.setup({ path = { package = pack_path } })

-- Enable profiler for debug/benchmark
if vim.env["MEO_ENABLE_PROFILE"] then
  deps.add("folke/snacks.nvim")
  require("snacks.profiler").startup({ startup = { event = "UIEnter" } })
end

-- Disable some useless standard plugins to speed up the startup.
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

-- Install the plugin manager and then load our plugin specs.
deps.add("loichyan/meow.nvim")
deps.now(function()
  -- Configure the preferred colorscheme
  vim.cmd.colorscheme("base16-gruvbox-material")
  local cache_token = function() return require("meowim.cache_token") end
  require("meow").setup({
    specs = { import = "meowim.plugins" },
    -- Enable import caching to reduce I/O loads.
    import_cache = not vim.env["MEO_DISABLE_CACHE"] and cache_token or nil,
    patch_mini = true,
    enable_snapshot = vim.env["MEO_DISABLE_SNAPSHOT"] == nil,
  })
end)

-- Bootstrap end
vim.g.meowim_startup_time = vim.uv.hrtime() - start_time
