if package.loaded["lazy"] then
  -- https://github.com/folke/lazy.nvim/issues/1180
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
  defaults = {
    lazy = false,
  },

  local_spec = false,

  git = {
    log = { "-4" },
    timeout = 60,
  },

  pkg = {
    enabled = false,
  },

  dev = {
    path = vim.fs.joinpath(os.getenv "HOME" or os.getenv "USERPROFILE", "Projects"),
    patterns = {
      os.getenv "USER" or os.getenv "USERNAME",
    },
  },

  install = {
    colorscheme = { "astrotheme", "default" },
  },

  ui = {
    border = "single",
    backdrop = 100,
    pills = true,
    size = { width = 0.9, height = 0.9 },
  },

  custom_keys = {
    ["<localleader>l"] = nil,
    ["<localleader>t"] = nil,
  },

  diff = {
    cmd = "diffview.nvim",
  },

  change_detection = {
    notify = false,
  },

  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "man",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "osc52",
        "rplugin",
        "spellfile",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },

  readme = {
    enabled = false,
  },
}

---@type LazyPluginSpec[]
local spec = {
  { "loichyan/DeltaVim" },
  { import = "deltavim.plugins" },
  { import = "deltavim.presets.mappings" },
}

require("lazy").setup(spec, opts)
