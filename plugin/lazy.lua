---@module "lazy"

if package.loaded["lazy"] then
  -- Keep plugin management separate from configuration logic.
  --
  -- Note that lazy.nvim overrides Neovim's built-in loader, causing
  -- pack/*/start/* to be sourced again. The overhead is minimal since the
  -- files are marked as no-op after lazy.nvim loads (using package.loaded).
  --
  -- For more details, see: https://github.com/folke/lazy.nvim/issues/1180
  --
  return
end

-- Neovim 0.10.1 includes logic to test whether a given terminal emulator
-- supports truecolor and sets the default value of `termguicolors` to true.
--
-- Unfortunately, the latter method can cause a "flash" visual effect in some
-- terminals (e.g., macOS's Terminal.app / nsterm) as truecolor is enabled and
-- then disabled again. It is also exacerbated by blocking operations (e.g.,
-- plugin manager setup). This behavior is suboptimal.
--
-- For more details, see: https://github.com/neovim/neovim/issues/29966
--
vim.o.termguicolors = true

local lazypath = vim.fs.joinpath(vim.fn.stdpath "data" --[[ @as string ]], "lazy", "lazy.nvim")
if not vim.uv.fs_stat(lazypath) then
  vim
    .system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim",
      lazypath,
    })
    :wait()
end
vim.opt.rtp:prepend(lazypath)

---@type LazyConfig
local opts = {
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "bugreport",
        "ftplugin",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "health",
        "logipat",
        "matchit",
        "matchparen",
        "netrw",
        "netrwFileHandlers",
        "netrwPlugin",
        "netrwSettings",
        "nvim",
        "optwin",
        "rplugin",
        "rrhelper",
        "spellfile",
        "spellfile_plugin",
        "synmenu",
        "syntax",
        "tar",
        "tarPlugin",
        "tohtml",
        "tutor",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
      },
    },
  },

  defaults = {
    lazy = false,
    version = false,
  },

  pkg = {
    enabled = false,
  },

  readme = {
    enabled = false,
  },

  change_detection = {
    enabled = false,
  },

  install = {
    colorscheme = { "astrotheme", "habamax" },
  },

  ui = {
    pills = false,
    border = "single",
    backdrop = 100,
  },

  dev = {
    path = vim.fs.joinpath(os.getenv "HOME" or os.getenv "USERPROFILE", "Projects"),
    patterns = {
      os.getenv "USER" or os.getenv "USERNAME",
    },
  },
}

---@type LazyPluginSpec[]
local spec = {
  { "loichyan/DeltaVim" },
  { import = "deltavim.plugins" },
  { import = "deltavim.presets.mappings" },
}

require("lazy").setup(spec, opts)
