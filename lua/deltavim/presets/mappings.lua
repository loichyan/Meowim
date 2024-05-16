return {
  {
    "astrocore",
    opts = function(_, opts)
      local icon, utils = require("astroui").get_icon, require "deltavim.utils"

      local map = opts.mappings
      utils.make_mappings(map, {
        n = {
          ------------------
          -- common mappings
          ------------------

          ["<Esc>"] = { "<Cmd>noh<CR><Esc>" },

          ["j"] = "common.j",
          ["k"] = "common.k",
          ["gw"] = "common.search_current_word",
          ["gx"] = "common.system_open",

          ["<C-H>"] = "common.left_window",
          ["<C-J>"] = "common.down_window",
          ["<C-K>"] = "common.up_window",
          ["<C-L>"] = "common.right_window",

          ["<C-S-h>"] = "common.resize_left",
          ["<C-S-j>"] = "common.resize_down",
          ["<C-S-k>"] = "common.resize_up",
          ["<C-S-l>"] = "common.resize_right",

          ["<Leader>-"] = "common.hsplit",
          ["<Leader>\\"] = "common.vsplit",

          ["<Leader>n"] = "common.new_file",
          ["<C-S>"] = "common.save_file",

          ["<Leader>w"] = "buffer.close",
          ["<Leader>W"] = "common.close_window",

          ["<Leader>l"] = { desc = icon("ActiveLSP", 1) .. "LSP" },
          ["<Leader>lf"] = "conform.format",

          --------------
          -- quickfix
          --------------

          ["<C-N>"] = "common.next_quickfix",
          ["<C-P>"] = "common.prev_quickfix",
          ["]x"] = "common.next_quickfix",
          ["[x"] = "common.prev_quickfix",

          ["<C-X>"] = "common.open_quickfix",
          ["<Leader>x"] = "common.open_quickfix",
          ["<Leader>X"] = "common.clear_quickfix",

          --------------
          -- diagnostics
          --------------

          ["gl"] = "diagnostic.hover_diagnostics",

          ["]d"] = "diagnostic.next_diagnostic",
          ["[d"] = "diagnostic.prev_diagnostic",
          ["]e"] = "diagnostic.next_error",
          ["[e"] = "diagnostic.prev_error",

          ["<Leader>ld"] = "diagnostic.list_document_diagnostics",
          ["<Leader>lD"] = "diagnostic.list_workspace_diagnostics",
          ["<Leader>le"] = "diagnostic.list_document_errors",
          ["<Leader>lE"] = "diagnostic.list_workspace_errors",
          ["<Leader>ls"] = "aerial.toggle",

          --------------------
          -- package management
          --------------------

          ["<Leader>p"] = { desc = icon("Package", 1) .. "Packages" },
          ["<Leader>pc"] = "lazy.check",
          ["<Leader>pi"] = "lazy.install",
          ["<Leader>pp"] = "lazy.show_status",
          ["<Leader>ps"] = "lazy.sync",
          ["<Leader>pu"] = "lazy.update",

          ------------------
          -- editor features
          ------------------

          ["<Leader>u"] = { desc = icon("Setting", 1) .. "UI/UX" },
          ["<Leader>ub"] = "toggles.toggle_background",
          ["<Leader>ud"] = "toggles.toggle_diagnostics",
          ["<Leader>ug"] = "toggles.toggle_signcolumn",
          ["<Leader>ui"] = "toggles.toggle_indent",
          ["<Leader>uI"] = "toggles.toggle_number",
          ["<Leader>ul"] = "toggles.toggle_statusline",
          ["<Leader>up"] = "toggles.toggle_paste",
          ["<Leader>us"] = "toggles.toggle_spell",
          ["<Leader>ut"] = "toggles.toggle_tabline",
          ["<Leader>uu"] = "toggles.toggle_url_match",
          ["<Leader>uw"] = "toggles.toggle_wrap",
          ["<Leader>uy"] = "toggles.toggle_syntax",
          ["<Leader>uz"] = "toggles.toggle_foldcolumn",
          ["<Leader>uA"] = "toggles.toggle_autochdir",
          ["<Leader>uN"] = "toggles.toggle_notifications",
          ["<Leader>uS"] = "toggles.toggle_conceal",

          ["<Leader>ua"] = "autopairs.toggle_global",
          ["<Leader>uc"] = "cmp.toggle_buffer",
          ["<Leader>uC"] = "cmp.toggle_global",
          ["<Leader>uf"] = "conform.toggle_buffer",
          ["<Leader>uF"] = "conform.toggle_global",
          ["<Leader>un"] = "notify.dismiss",
          ["<Leader>ur"] = "illuminate.toggle_buffer",
          ["<Leader>uR"] = "illuminate.toggle_global",
          ["<Leader>uU"] = "colorizer.toggle_buffer",
          ["<Leader>u|"] = "indent-blankline.toggle_global",

          --------------------
          -- editor components
          --------------------

          ["<Leader>h"] = "alpha.toggle",
          ["<Leader>e"] = "neo-tree.focus",

          --------------------
          -- buffer management
          --------------------

          ["[b"] = "buffer.prev",
          ["]b"] = "buffer.next",
          ["<C-,>"] = "buffer.prev",
          ["<C-.>"] = "buffer.next",

          ["<b"] = "buffer.move_left",
          [">b"] = "buffer.move_right",

          ["<Leader>b"] = { desc = icon("Tab", 1) .. "Buffers" },
          ["<Leader>bH"] = "buffer.close_left",
          ["<Leader>bL"] = "buffer.close_right",
          ["<Leader>bQ"] = "buffer.close_others",

          ["<Leader>bs"] = { desc = icon("Sort", 1) .. "Sort buffers" },
          ["<Leader>bse"] = "buffer.sort_by_extension",
          ["<Leader>bsf"] = "buffer.sort_by_filename",
          ["<Leader>bsp"] = "buffer.sort_by_path",
          ["<Leader>bsn"] = "buffer.sort_by_number",
          ["<Leader>bsm"] = "buffer.sort_by_modification",

          ["<Leader>bb"] = "heirline.pick_select",
          ["<Leader>bq"] = "heirline.pick_close",
          ["<Leader>b\\"] = "heirline.pick_hsplit",
          ["<Leader>b-"] = "heirline.pick_vsplit",

          ["[t"] = "tab.prev",
          ["]t"] = "tab.next",

          ["<Leader>t"] = { desc = icon("Window", 1) .. "Tabs" },
          ["<Leader>tn"] = "tab.new",
          ["<Leader>tq"] = "tab.close",
          ["<Leader>th"] = "tab.goto_first",
          ["<Leader>tl"] = "tab.goto_last",

          ------------
          -- telescope
          ------------

          ["<Leader>f"] = { desc = icon("Search", 1) .. "Find" },
          ["<Leader>'"] = "telescope.find_marks",
          ['<Leader>"'] = "telescope.find_registers",
          ["<Leader>,"] = "telescope.find_buffers",
          ["<Leader>/"] = "telescope.find_buffer_fuzzy",
          ["<Leader>:"] = "telescope.find_command_history",
          ["<Leader><CR>"] = "telescope.resume",
          ["<Leader><Leader>"] = "telescope.find_files",
          ["<Leader>fa"] = "telescope.find_config_files",
          ["<Leader>fc"] = "telescope.find_commands",
          ["<Leader>fC"] = "telescope.find_autocmds",
          ["<Leader>ff"] = "telescope.find_files",
          ["<Leader>fF"] = "telescope.find_all_files",
          ["<Leader>fg"] = "telescope.find_words",
          ["<Leader>fG"] = "telescope.find_words_from_all",
          ["<Leader>fh"] = "telescope.find_help_tags",
          ["<Leader>fH"] = "telescope.find_man_pages",
          ["<Leader>fk"] = "telescope.find_keymaps",
          ["<Leader>fo"] = "telescope.find_recent_files",
          ["<Leader>fu"] = "telescope.find_colorschemes",
          ["<Leader>fU"] = "telescope.find_highlights",
          ["<Leader>fw"] = "telescope.find_current_word",
          ["<Leader>f'"] = "telescope.find_marks",
          ['<Leader>f"'] = "telescope.find_registers",
          ["<Leader>f,"] = "telescope.find_buffers",
          ["<Leader>f/"] = "telescope.find_buffer_fuzzy",
          ["<Leader>f:"] = "telescope.find_command_history",
          ["<Leader>f<CR>"] = "telescope.resume",

          ["<Leader>fn"] = "notify.find",
          ["<Leader>ft"] = "todo-comments.find",
          ["<Leader>fT"] = "todo-comments.find_all_kinds",

          ---------------------
          -- session management
          ---------------------

          ["<Leader>q"] = { desc = icon("Session", 1) .. "Session" },
          ["<Leader>ql"] = "resession.load_dir_cwd",
          ["<Leader>qL"] = "resession.load_last",
          ["<Leader>qs"] = "resession.save_dir",
          ["<Leader>qS"] = "resession.save",
          ["<Leader>qt"] = "resession.save_tab",
          ["<Leader>qf"] = "resession.load",
          ["<Leader>qF"] = "resession.load_dir",
          ["<Leader>qd"] = "resession.delete_dir",
          ["<Leader>qD"] = "resession.delete",
          ["<Leader>qq"] = "common.quit",

          ------------------
          -- git integration
          ------------------

          ["[g"] = "gitsigns.prev_hunk",
          ["]g"] = "gitsigns.next_hunk",

          ["<Leader>g"] = { desc = icon("Git", 1) .. "Git" },
          ["<Leader>ga"] = "telescope.git_status",
          ["<Leader>gb"] = "telescope.git_branches",
          ["<Leader>gc"] = "telescope.git_buffer_commits",
          ["<Leader>gC"] = "telescope.git_global_commits",
          ["<Leader>gk"] = "gitsigns.hover_blame",
          ["<Leader>gK"] = "gitsigns.hover_full_blame",
          ["<Leader>gP"] = "gitsigns.hover_diff",
          ["<Leader>gp"] = "gitsigns.hover_hunk",
          ["<Leader>gr"] = "gitsigns.reset_hunk",
          ["<Leader>gR"] = "gitsigns.reset_buffer",
          ["<Leader>gs"] = "gitsigns.stage_hunk",
          ["<Leader>gS"] = "gitsigns.stage_buffer",
          ["<Leader>gu"] = "gitsigns.undo_stage_hunk",

          ------------
          -- utilities
          ------------

          ["[T"] = "todo-comments.prev",
          ["]T"] = "todo-comments.next",

          ["]]"] = "illuminate.next_reference",
          ["[["] = "illuminate.prev_reference",

          ["]r"] = "illuminate.next_reference",
          ["[r"] = "illuminate.prev_reference",
        },

        t = {
          ["<C-H>"] = "common.left_window",
          ["<C-J>"] = "common.down_window",
          ["<C-K>"] = "common.up_window",
          ["<C-L>"] = "common.right_window",
        },

        x = {
          ["<"] = { "<gv", noremap = true },
          [">"] = { ">gv", noremap = true },
          ["j"] = "common.j",
          ["k"] = "common.k",

          ["<Leader>l"] = { desc = icon("ActiveLSP", 1) .. "LSP" },
          ["<Leader>lf"] = "conform.format",
        },
      })
      -- override mappings by other available plugins
      utils.make_mappings(map, {
        n = {
          ["<C-H>"] = "smart-splits.left_window",
          ["<C-J>"] = "smart-splits.down_window",
          ["<C-K>"] = "smart-splits.up_window",
          ["<C-L>"] = "smart-splits.right_window",

          ["<C-S-h>"] = "smart-splits.resize_left",
          ["<C-S-j>"] = "smart-splits.resize_down",
          ["<C-S-k>"] = "smart-splits.resize_up",
          ["<C-S-l>"] = "smart-splits.resize_right",

          ["<Leader>ld"] = "telescope.find_document_diagnostics",
          ["<Leader>lD"] = "telescope.find_workspace_diagnostics",
          ["<Leader>le"] = "telescope.find_document_errors",
          ["<Leader>lE"] = "telescope.find_workspace_errors",
        },
      })

      -- copy/paste using system clipboard
      for _, k in ipairs { "y", "Y", "d", "D", "p", "P" } do
        local lhs, rhs = "<LocalLeader>" .. k, '"+' .. k
        map.n[lhs] = { rhs }
        map.x[lhs] = { rhs }
      end
    end,
  },

  {
    "astrolsp",
    opts = function(_, opts)
      local utils = require "deltavim.utils"
      utils.make_mappings(opts.mappings, {
        n = {
          ------
          -- LSP
          ------

          ["K"] = "lsp.hover",
          ["gD"] = "lsp.goto_declaration",
          ["gd"] = "lsp.goto_definition",
          ["gI"] = "lsp.list_implementations",
          ["gK"] = "lsp.hover_signature_help",
          ["gr"] = "lsp.list_references",
          ["gy"] = "lsp.goto_type_definition",

          ["<Leader>la"] = "lsp.code_action",
          ["<Leader>lg"] = "lsp.list_document_symbols",
          ["<Leader>lG"] = "lsp.list_workspace_symbols",
          ["<Leader>lh"] = "lsp.hover_signature_help",
          ["<Leader>li"] = "lspconfig.show_info",
          ["<Leader>lI"] = "null-ls.show_info",
          ["<Leader>ll"] = "lsp.refresh_codelens",
          ["<Leader>lL"] = "lsp.run_codelens",
          ["<Leader>lr"] = "lsp.rename",

          ["<Leader>uh"] = "lsp.toggle_buffer_inlay_hints",
          ["<Leader>uH"] = "lsp.toggle_global_inlay_hints",
          ["<Leader>uL"] = "lsp.toggle_global_codelens",
          ["<Leader>uY"] = "lsp.toggle_buffer_semantic_tokens",
        },

        x = {
          ["<Leader>la"] = "lsp.code_action",
        },
      })
      -- override mappings by other available plugins
      utils.make_mappings(opts.mappings, {
        n = {
          ["gd"] = "telescope.goto_definition",
          ["gI"] = "telescope.find_implementations",
          ["gr"] = "telescope.find_references",
          ["gy"] = "telescope.goto_type_definition",

          ["<Leader>lg"] = "telescope.find_document_symbols",
          ["<Leader>lG"] = "telescope.find_workspace_symbols",
        },
      })
    end,
  },
}
