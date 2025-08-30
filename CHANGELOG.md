# Changelog

All notable changes to this project will be documented in this file.

<!--
Here's a template for each release section. This file should only include updates
that are noticeable to end users between two releases. For developers, this project
follows <https://www.conventionalcommits.org/en/v1.0.0/> to track changes.

## [20250101]

### Added

- (**breaking**) Always place breaking changes at the top of each subsection.
- Append other changes in chronological order under the appropriate subsection.
- Additionally, you may use `{{variable name}}` as a placeholder for the value
  of a named variable, which includes:
  - `PRNUM`: the number of the pull request
  - `DATE`: the date in `YYYY-MM-DD` format whenever the pull request is updated

### Changed

### Deprecated

### Removed

### Fixed

### Security

[20250101]: https://github.com/user/repo/compare/v20240101..v20250101
-->

## [Unreleased]

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
[Unreleased]: https://github.com/loichyan/Meowim/compare/v20250828..HEAD
