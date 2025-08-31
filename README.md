# 😺 Meowim

Meowim is a [mini.nvim](https://github.com/nvim-mini/mini.nvim) powered launch
point for your personal development environment.

![showcase](https://loichyan.github.io/dotfiles/assets/showcase.jpg)
[Information](https://github.com/loichyan/dotfiles/tree/snapshot#information)

## ✨ Features

- 🔋 20+ pre-configured mini modules
- 🪄 A clean UI with a smooth theme
- ⌨️ Sensible default keymaps
- ⚡ Lazy-loading of most plugins
- 💤 Plugin management in the [lazy](https://github.com/folke/lazy.nvim) way

## 📋 Requirements

- the [latest stable Neovim](https://github.com/neovim/neovim/releases/latest)
- Git
- a C compiler for nvim-treesitter (see
  [here](https://github.com/nvim-treesitter/nvim-treesitter#requirements))
- [ripgrep](https://github.com/BurntSushi/ripgrep) (*required by mini.pick*)
- a [NerdFont](https://www.nerdfonts.com/) >= **3.0** (*optional but highly
  recommended*)

## 🚗 Quick start

[Fork](https://github.com/loichyan/Meowim/fork) this repo so that you have your
own copy that you can modify, then install by:

```sh
# 1) Make a backup for your current configurations
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
# 2) Clone your fork
git clone https://github.com/<your_id>/Meowim ~/.config/nvim
```

Additionally, you can check out [my own fork](https://github.com/loichyan/nvim)
for inspiration.

## 🎯 Goals

Meowim aims to provide some tweaks to the defaults of mini.nvim, along with
several useful plugins that aren't included in mini.nvim. As a result, new
plugins generally won't be added to the codebase. Moreover, if a non-mini plugin
eventually has a mini alternative, it may be replaced by that.

On the other hand, Meowim won't offer an extendable layer over its codebase like
[LazyVim](https://www.lazyvim.org/). It more or less follows the philosophy of
[kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), because no
distribution meets everyone's needs (which is also one reason this project
exists).

## ♥️ Special Thanks

- [mini.nvim](https://github.com/nvim-mini/mini.nvim) for the fundamental
  contribution to the birth of this project.
- [LazyVim](https://github.com/LazyVim/LazyVim) for providing many excellent
  configuration snippets used in this project.

## ⚖️ License

Licensed under GNU General Public License, Version 3.0 ([LICENSE](LICENSE) or
<https://www.gnu.org/licenses/gpl-3.0>).
