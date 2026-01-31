# Changelog

All notable changes to this project will be documented in this file.

<!--
Here's a template for each release section. This file should only include updates
that are noticeable to end users between two releases. For developers, this project
follows <https://www.conventionalcommits.org/en/v1.0.0/> to track changes.
-->

## [Unreleased]

## [20260131]

This release focuses mainly on UI and keymaps. Here are the notable updates:

- (**breaking**, [509861c]) Replace mini.statusline and mini.tabline with
  [meoline.nvim]—my new plugin that provides a minimal statusline, tabline, and
  winbar. It looks similar to the current UI and has a much simpler
  implementation (~800 LoC), though it's opinionated and supports only a few
  customization options.
- (**breaking**, [c3fe7e2]) Prefer single quotes whenever possible. Single
  quotes look cleaner than double quotes and are preferred by 'mini.nvim' and
  Neovim's built-in modules.
- (**breaking**, [9df50b1], [99bdf34], [622e26b]) Refine keymaps to interact
  with git:
  - Remap `<Leader>ca` to `<Leader>cb`.
  - Remap `<Leader>cr` to `<Leader>cx`.
  - Remap `[gh`, `]gh` to `[g`, `]g`.
  - Remap `[gc`, `]gc` to `[/`, `]/`.
  - Remap `<Leader>gd` to `<LocalLeader>g`.
  - Remap `<Leader>gD` to `<Leader>gd`.
  - Remap `<Leader>gf` to `<Leader>gx`.
  - Remap `<Leader>gg` to `<Leader>G`.
  - Remap `<Leader>gH` to `<Leader>gl`.
  - Remap `<Leader>gl` to `<Leader>gL`.
  - Remap `<Leader>gL` to `<Leader>go`.
- ([75e0e8f], [63a9b49]) Improve builtin fold support:
  - Enable 'foldcolumn' on Neovim 0.12.
  - Automatically select a proper expression to obtain fold levels.

Besides meoline.nvim, two other plugins are added:

- [tiagovla/scope.nvim] is added for buffers-per-tab support.
- [SmiteshP/nvim-navic] is used by meoline.nvim to fetch winbar items.

[509861c]: https://github.com/loichyan/Meowim/commit/509861cfd136991cd068686cb0d4afb7ca5baf6
[c3fe7e2]: https://github.com/loichyan/Meowim/commit/c3fe7e205d592c70dd33c4ace9c9e309bf1e35a7
[9df50b1]: https://github.com/loichyan/Meowim/commit/9df50b1b69dee93b1931253d980800b14780c9cd
[99bdf34]: https://github.com/loichyan/Meowim/commit/99bdf34a99854b267201af3dfd5a7111022ac8b8
[622e26b]: https://github.com/loichyan/Meowim/commit/622e26b82adfc5631cedf0aa5ee55f709105fcd6
[75e0e8f]: https://github.com/loichyan/Meowim/commit/75e0e8f9fa3e111bba77ca01984a30a9ef332dbf
[63a9b49]: https://github.com/loichyan/Meowim/commit/63a9b49d5053b3783f8554fbf663b6eaf63facc9
[meoline.nvim]: https://github.com/loichyan/meoline.nvim
[tiagovla/scope.nvim]: https://github.com/tiagovla/scope.nvim
[SmiteshP/nvim-navic]: https://github.com/SmiteshP/nvim-navic

## [20260104]

This release includes several significant changes to the editing experience and
UI enhancements. Here are some notable updates:

- (**breaking**, [a54b2e8]) Migrate to 'main' branch of nvim-treesitter and
  related plugins.
- (**breaking**, [c91e011]) Replace mini.completion with blink.cmp.
  mini.completion generally performs well, but some LSP servers can be
  problematic. For example, clangd might insert extra leading characters, while
  ts_ls may occasionally lose completions or fail to respond to autocompletion
  requests. mini.completion expects servers to follow the LSP specification, but
  a server might be implemented with a different interpretation, leading to
  incompatibility with mini.completion. blink.cmp includes several
  [hacks](https://github.com/saghen/blink.cmp/tree/v1.7.0/lua/blink/cmp/sources/lsp/hacks)
  to make those servers function out of the box. So, let’s focus more on editing
  and less on the editor 😊
- ([275d32d]) Add keymaps to toggle `virtual_text`.
  - (**breaking**) Remap `<LocalLeader>d` to `<LocalLeader>D` (it toggles all
    diagnostics).
  - Use `<LocalLeader>d` to toggle `virtual_text`.
- (**breaking**, [bd6e630]) Revert the default colorscheme to gruvbox-material.
  gruvbox-carbon is a bit too dark, and the contrast ratio is too high 🙃

[a54b2e8]: https://github.com/loichyan/Meowim/commit/a54b2e8f2be0544601cba5a7e816f31585570338
[c91e011]: https://github.com/loichyan/Meowim/commit/c91e011cbc395cab766b06ba2dae158c0078e3bf
[275d32d]: https://github.com/loichyan/Meowim/commit/275d32d94211f1c21d8b4c4e2ab0f31aa3a3764c
[bd6e630]: https://github.com/loichyan/Meowim/commit/bd6e63098bad8f792f55fbdbde64da2f515f6a1f

## [20250828]

This month's updates mainly focus on typing experience, including refinements on
keymaps and auto-completion. Noticeable changes are listed below:

- ([2832af2], [055071f], [414b46c]) Rework mappings to interact with Git:
  - (**breaking**) Remap keys to resolve conflicts to `<Leader>c*`.
  - (**breaking**) Remap `<Leader>gl` to `<Leader>gg` (it shows various *g*it
    stuffs).
  - (**breaking**) Remap `<Ledaer>gL` to `<Leader>gH` (it shows "buffer
    *H*istory").
  - (**breaking**) Remap `<Leader>gH` to `<Leader>gl` (it shows "workspace
    *L*ogs").
  - (**breaking**) Remap mappings to stage/reset hunks to `ghh`, `ghH`, `gHh`
    and `gHH`.
  - Use `<Leader>c{C,I}` select conflicts in entire buffer.
  - Use `<Leader>g{c,C,A}` to commit Git changes.
  - Use `<Leader>gs` to pick Git status.
  - Add useful shortcuts in buffers opened by mini.git.
- ([49ed883]) Refine completion experience, with the following designs:
  1. Only the first keyword part of an item is used as the completion word,
     which means for a function item, only its name will be inserted when you
     select it through `<C-n>/<C-p>`.
  2. Only a few keys are intended to accept a completion, currently `<CR>`, `(`
     and `<C-y>` included. This is different from mini.completion, which accepts
     all non-keyword chars.
  3. Some discussions are available in [mini.nvim#1938] and [mini.nvim#1944].
- ([d0113f5]) Add a new high-contrast variant for base16-gruvbox. Sometimes,
  high-contrast themes are more impactful :wink:
- ([c74a720]) Enable mini.comment, which is almost the same as Neovim's builtin
  (since they have the same author :heart:) but provides more options for
  customization.

[2832af2]: https://github.com/loichyan/Meowim/commit/2832af2a8cf0fea3095fd1817ac8718879b89bb5
[055071f]: https://github.com/loichyan/Meowim/commit/055071fc367e2a69a2cbf286e28c5919e1304604
[414b46c]: https://github.com/loichyan/Meowim/commit/414b46c622eccccf644517206ca057672256b653
[49ed883]: https://github.com/loichyan/Meowim/commit/49ed883c4488c36600902f6c85a43e3d6f49f529
[d0113f5]: https://github.com/loichyan/Meowim/commit/d0113f590104b9af3d690791087eec3b17ff87f2
[c74a720]: https://github.com/loichyan/Meowim/commit/c74a72057e86ca7aefd82b306ece75bbd281301d
[mini.nvim#1938]: https://github.com/echasnovski/mini.nvim/issues/1938
[mini.nvim#1944]: https://github.com/echasnovski/mini.nvim/issues/1944

## [20250809]

This week contains a bunch of updates (more than the total from last month!). I
decided to sync them early. Although there are 40+ commits, most of them are
refactors focused on performance and ergonomics. The notable changes include:

1. (**breaking**) The structure of many spec modules has been refined for
   readability and maintainability.
2. (**breaking**) The bindings for `<Leader>fr` and `<Leader>fR` have been
   swapped.
3. `meowim.config.keymaps` has been reformatted with consistent alignment to
   make entries more friendly to Git diffs.
4. Startup time has been reduced by ~15% (not significantly, though).
5. A few more useful infos have been added to the statusline.
6. The pairing algorithm of mini.pairs has been improved to handle strings.
7. The 'indent' module of treesitter has been re-enabled, which was previously
   disabled in (#29).

## [20250731]

Basically, I sync changes with my own fork every month, along with snapshot
updates. Currently, this project does not plan to follow semantic versioning.
Nevertheless, breaking changes will be documented in the related commits.
Additionally, I will also document some notable changes in each PR. This month's
updates include:

- (**breaking**) The `<Leader>gs` mapping now stages the hunk at the cursor.
  Previously, this binding staged hunks in the entire buffer, which has now been
  re-mapped to `<Leader>gS`.
- The Base16 themes included in this repo can respond to changes in
  `vim.o.background`.
- Add grep pickers (both live and non-live) for
  [ast-grep](https://ast-grep.github.io/), a powerful structural search and
  replace tool using treesitter. This is particularly useful for languages that
  lack good LSP support or for which a LSP server is just too expensive to
  start.

[20250731]: https://github.com/loichyan/Meowim/tree/v20250731
[20250809]: https://github.com/loichyan/Meowim/compare/v20250731..v20250809
[20250828]: https://github.com/loichyan/Meowim/compare/v20250809..v20250828
[20260104]: https://github.com/loichyan/Meowim/compare/v20250828..v20260104
[20260131]: https://github.com/loichyan/Meowim/compare/v20260104..v20260131
[Unreleased]: https://github.com/loichyan/Meowim/compare/v20260131..HEAD
