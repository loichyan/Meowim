if package.loaded["lazy"] then
  -- Note that lazy.nvim overrides Neovim's built-in loader, causing
  -- pack/*/start/* to be sourced again. The overhead is minimal since we mark
  -- the file as no-op after lazy.nvim loads (using package.loaded).
  --
  -- https://github.com/folke/lazy.nvim/issues/1180.
  --
  return
end

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

local deltavim = require "deltavim"
deltavim.setup {
  mapleader = " ",
  maplocalleader = "\\",
  icons_enabled = true,
  pin_plugins = vim.env.DELTA_PIN_PLUGINS == "1",
}

require("lazy").setup {
  spec = {
    {
      "loichyan/DeltaVim",
      priority = 1000,
    },
    { import = "deltavim.plugins" },
    { import = "deltavim.presets.mappings" },
  },

  dev = {
    path = vim.fn.stdpath "config",
    patterns = { "loichyan" },
    fallback = false,
  },

  -- These either have a direct replacement (e.g., matchit -> matchup) or
  -- are just straight-up obsolete.
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "bugreport",
        "ftplugin",
        "getscriptPlugin",
        "getscript",
        "gzip",
        "health",
        "logipat",
        "matchit",
        "matchparen",
        "netrwFileHandlers",
        "netrwPlugin",
        "netrwSettings",
        "netrw",
        "nvim",
        "optwin",
        "rplugin",
        "rrhelper",
        "spellfile",
        "spellfile_plugin",
        "synmenu",
        "syntax",
        "tarPlugin",
        "tar",
        "tohtml",
        "tutor",
        "vimballPlugin",
        "vimball",
        "zipPlugin",
        "zip",
      },
    },
  },

  -- https://github.com/folke/lazy.nvim/issues/1008
  change_detection = {
    enabled = false,
  },

  -- lazy can generate helptags from the headings in markdown readme files, so
  -- :help works even for plugins that don't have vim docs. In practise though,
  -- most README aren't made to be appropriate documentation (beyond the basic
  -- setup), so this may confuse the average users.
  readme = {
    enabled = false,
  },

  -- Using a direct configuration often means that the user just wants an
  -- out-of-the-box experience and pills show categories that are (IMO) more
  -- geared toward plugin developers in general. Chances are that this is not
  -- interesting for average users.
  ui = {
    pills = false,
  },
}
