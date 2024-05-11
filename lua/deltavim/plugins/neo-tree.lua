---@type LazyPluginSpec
return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",

  dependencies = {
    { "MunifTanjim/nui.nvim", lazy = true },
    {
      "AstroNvim/astrocore",
      ---@param opts AstroCoreOpts
      opts = function(_, opts)
        require("deltavim.utils").merge(opts.autocmds, {
          neotree_start = {
            {
              event = "BufEnter",
              desc = "Open Explorer on startup with directory",
              callback = function()
                if
                  package.loaded["neo-tree"]
                  or not require("astrocore").is_available "neo-tree.nvim"
                then
                  return true
                end

                -- TODO: remove vim.loop after NeoVim v0.9
                local stats = (vim.uv or vim.loop).fs_stat(vim.api.nvim_buf_get_name(0))
                if stats and stats.type == "directory" then
                  require("lazy").load { plugins = { "neo-tree.nvim" } }
                  return true
                end
              end,
            },
          },
          neotree_refresh = {
            {
              event = "TermClose",
              desc = "Refresh Explorer sources when closing terminal",
              callback = function()
                local ok, manager = pcall(require, "neo-tree.sources.manager")
                if not ok then return true end
                if package.loaded["neo-tree.sources.filesystem"] then
                  manager.refresh "filesystem"
                end
              end,
            },
          },
        })
      end,
    },
  },

  opts = function()
    local astro = require "astrocore"
    local icon = require("astroui").get_icon

    -- mappings
    local commands = {
      system_open = function(state)
        -- TODO: remove astro.system_open after NeoVim v0.9
        (vim.ui.open or astro.system_open)(state.tree:get_node():get_id())
      end,

      parent_or_close = function(state)
        local node = state.tree:get_node()
        if node:has_children() and node:is_expanded() then
          state.commands.toggle_node(state)
        else
          require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
        end
      end,

      child_or_open = function(state)
        local node = state.tree:get_node()
        if node:has_children() then
          if not node:is_expanded() then
            state.commands.toggle_node(state)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
          end
        else
          state.commands.open(state)
        end
      end,
    }
    local mappings = {
      ["<S-CR>"] = "system_open",
      ["o"] = "open",
      ["O"] = "system_open",
      ["h"] = "parent_or_close",
      ["l"] = "child_or_open",
    }

    -- additional mappings
    if astro.is_available "telescope.nvim" then
      commands.find_in_dir = function(state)
        local node = state.tree:get_node()
        local path = node.type == "file" and node:get_parent_id() or node:get_id()
        require("telescope.builtin").find_files { cwd = path }
      end
      mappings["F"] = "find_in_dir"
    end

    return {
      -- appearance
      default_component_configs = {
        indent = {
          padding = 0,
          expander_collapsed = icon "FoldClosed",
          expander_expanded = icon "FoldOpened",
        },
        icon = {
          folder_closed = icon "FolderClosed",
          folder_open = icon "FolderOpen",
          folder_empty = icon "FolderEmpty",
          folder_empty_open = icon "FolderEmpty",
          default = icon "DefaultFile",
        },
        modified = { symbol = icon "FileModified" },
        git_status = {
          symbols = {
            added = icon "GitAdd",
            deleted = icon "GitDelete",
            modified = icon "GitChange",
            renamed = icon "GitRenamed",
            untracked = icon "GitUntracked",
            ignored = icon "GitIgnored",
            unstaged = icon "GitUnstaged",
            staged = icon "GitStaged",
            conflict = icon "GitConflict",
          },
        },
        diagnostics = {
          symbols = {
            hint = icon "DiagnosticHint",
            info = icon "DiagnosticInfo",
            warn = icon "DiagnosticWarn",
            error = icon "DiagnosticError",
          },
        },
      },
      -- common
      auto_clean_after_session_restore = true,
      close_if_last_window = true,
      commands = commands,
      window = {
        width = 35,
        mappings = mappings,
        mapping_options = {
          noremap = true,
          nowait = true,
          silent = true,
        },
      },
      -- events
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function(_)
            vim.opt_local.signcolumn = "auto"
            vim.opt_local.foldcolumn = "0"
          end,
        },
        --auto close
        {
          event = "file_opened",
          handler = function() require("neo-tree.command").execute { action = "close" } end,
        },
      },
      -- sources
      sources = { "filesystem" },
      filesystem = {
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = vim.fn.has "win32" ~= 1,
        filtered_items = {
          hide_dotfiles = false,
          never_show = { ".git" },
        },
      },
    }
  end,
}
