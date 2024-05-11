return {
  "AstroNvim/astrocore",
  opts = function(_, opts)
    local config = require("deltavim").config.autocmds
    local astro, buf_utils = require "astrocore", require "astrocore.buffer"

    require("deltavim.utils").merge(opts.autocmds, {
      auto_quit = {
        {
          event = "WinClosed",
          desc = "Quit NeoVim if only sidebar windows are list",
          callback = function()
            local wins = vim.api.nvim_tabpage_list_wins(0)
            if #wins <= 1 then return end
            local sidebars = config.auto_quit.sidebar_filetypes

            for _, winid in ipairs(wins) do
              if vim.api.nvim_win_is_valid(winid) then
                local filetype = vim.bo[vim.api.nvim_win_get_buf(winid)].filetype
                if not sidebars[filetype] then
                  -- early return if any visible windows are not sidebar
                  return
                else
                  -- only count filetypes once
                  sidebars[filetype] = nil
                end
              end
            end

            if #vim.api.nvim_list_tabpages() > 1 then
              vim.cmd.tabclose() -- close current tab
            else
              vim.cmd.qall() -- quit NeoVim
            end
          end,
        },
      },

      auto_view = {
        {
          event = { "BufWinLeave", "BufWritePost", "WinLeave" },
          desc = "Save view with mkview for real files",
          callback = function(args)
            if vim.b[args.buf].view_activated then
              vim.cmd.mkview { mods = { emsg_silent = true } }
            end
          end,
        },
        {
          event = "BufWinEnter",
          desc = "Try to load file view if available and enable view saving for real files",
          callback = function(args)
            local bufnr = args.buf
            local b, bo = vim.b[bufnr], vim.bo[bufnr]
            if b.view_activated then return end

            local filetype = bo.filetype
            local buftype = bo.buftype
            local ignore_filetypes = config.auto_view.ignored_filetypes

            if buftype == "" and filetype and filetype ~= "" and not ignore_filetypes[filetype] then
              b.view_activated = true
              vim.cmd.loadview { mods = { emsg_silent = true } }
            end
          end,
        },
      },

      bufferline = {
        {
          event = { "BufAdd", "BufEnter", "TabNewEntered" },
          desc = "Update buffers when adding new buffers",
          callback = function(args)
            local bufnr = args.buf
            if not buf_utils.is_valid(bufnr) then return end

            -- update current buffer
            local current_buf = buf_utils.current_buf
            if bufnr ~= current_buf then
              buf_utils.last_buf = buf_utils.is_valid(current_buf) and current_buf or nil
              buf_utils.current_buf = bufnr
            end

            local bufs = vim.t.bufs or {}
            if vim.tbl_contains(bufs, bufnr) then return end

            -- update buffer list
            table.insert(bufs, bufnr)
            ---@diagnostic disable-next-line: inject-field
            vim.t.bufs = bufs
            astro.event "BufsUpdated"
            vim.cmd.redrawtabline()
          end,
        },
        {
          event = { "BufDelete", "TermClose" },
          desc = "Update buffers when deleting buffers",
          callback = function(args)
            -- remove from each tab
            local removed
            for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
              local bufs = vim.t[tab].bufs
              if bufs then
                for i, bufnr in ipairs(bufs) do
                  if bufnr == args.buf then
                    table.remove(bufs, i)
                    vim.t[tab].bufs = bufs
                    removed = true
                    break
                  end
                end
              end
            end

            -- update buffer list
            if not removed then return end
            astro.event "BufsUpdated"
            vim.cmd.redrawtabline()
          end,
        },
      },

      checktime = {
        {
          event = { "FocusGained", "TermClose", "TermLeave" },
          desc = "Check if buffers changed on editor focus",
          command = "checktime",
        },
      },

      create_dir = {
        {
          event = "BufWritePre",
          desc = "Automatically create parent directories if they don't exist when saving a file",
          callback = function(args)
            if not buf_utils.is_valid(args.buf) then return end
            vim.fn.mkdir(
              vim.fn.fnamemodify(vim.loop.fs_realpath(args.match) or args.match, ":p:h"),
              "p"
            )
          end,
        },
      },

      editorconfig_filetype = {
        {
          event = "FileType",
          desc = "Configure editorconfig after filetype detection to override `ftplugin`s",
          callback = function(args)
            ---@diagnostic disable-next-line: undefined-field
            if vim.F.if_nil(vim.b.editorconfig, vim.g.editorconfig) then
              local editorconfig_avail, editorconfig = pcall(require, "editorconfig")
              if editorconfig_avail then editorconfig.config(args.buf) end
            end
          end,
        },
      },

      file_user_events = {
        {
          event = { "BufReadPost", "BufNewFile", "BufWritePost" },
          desc = "NeoVim user events for file detection (AstroFile and AstroGitFile)",
          callback = function(args)
            local bufnr = args.buf
            if vim.b[bufnr].astrofile_checked then return end
            vim.b[bufnr].astrofile_checked = true

            vim.schedule(function()
              if not vim.api.nvim_buf_is_valid(bufnr) then return end
              local current_file = vim.api.nvim_buf_get_name(bufnr)
              if not vim.g.vscode and (current_file == "" or vim.bo[bufnr].buftype == "nofile") then
                return
              end
              pcall(vim.api.nvim_del_augroup_by_name, "file_user_events")

              -- fire AstroFile
              astro.event "File"

              -- check git repo and fire AstroGitFile
              if vim.fn.executable "git" == 1 then
                local folder = vim.fn.fnamemodify(current_file, ":p:h")
                if vim.fn.has "win32" == 1 then folder = ('"%s"'):format(folder) end
                if
                  astro.cmd({ "git", "-C", folder, "rev-parse" }, false) or astro.file_worktree()
                then
                  astro.event "GitFile"
                end
              end

              -- trigger original events
              vim.schedule(function()
                if buf_utils.is_valid(bufnr) then
                  vim.api.nvim_exec_autocmds(args.event, { buffer = bufnr, data = args.data })
                end
              end)
            end)
          end,
        },
      },

      highlighturl = {
        {
          event = { "VimEnter", "FileType", "BufEnter", "WinEnter" },
          desc = "URL Highlighting",
          callback = function() astro.set_url_match() end,
        },
      },

      highlightyank = {
        {
          event = "TextYankPost",
          desc = "Highlight yanked text",
          pattern = "*",
          callback = function() vim.highlight.on_yank() end,
        },
      },

      large_buf_settings = {
        {
          event = "User",
          desc = "Disable certain functionality on very large files",
          pattern = "AstroLargeBuf",
          callback = function(args)
            local bufnr = args.buf
            local opt, b = vim.opt_local, vim.b[bufnr]

            opt.wrap = true -- enable wrap, long lines in vim are slow
            opt.list = false -- disable list chars
            b.autoformat = false -- disable autoformat on save
            b.cmp_enabled = false -- disable completion
            b.miniindentscope_disable = true -- disable indent scope
            b.matchup_matchparen_enabled = 0 -- disable vim-matchup

            local ibl_avail, ibl = pcall(require, "ibl") -- disable indent-blankline
            if ibl_avail then ibl.setup_buffer(bufnr, { enabled = false }) end

            local illuminate_avail, illuminate = pcall(require, "illuminate.engine") -- disable vim-illuminate
            if illuminate_avail then illuminate.stop_buf(bufnr) end

            local rainbow_avail, rainbow = pcall(require, "rainbow-delimiters") -- disable rainbow-delimiters
            if rainbow_avail then rainbow.disable(bufnr) end
          end,
        },
      },

      q_close_windows = {
        {
          event = "FileType",
          desc = "Make q close certain windows",
          callback = function(args)
            if not config.q_close_windows.filetypes[vim.bo[args.buf].filetype] then return end
            vim.keymap.set("n", "q", "<Cmd>close<CR>", {
              desc = "Close window",
              buffer = args.buf,
              silent = true,
              nowait = true,
            })
          end,
        },
      },

      terminal_settings = {
        {
          event = "TermOpen",
          desc = "Disable line number/fold column/sign column for terinals",
          callback = function()
            local opt = vim.opt_local
            opt.number = false
            opt.relativenumber = false
            opt.foldcolumn = "0"
            opt.signcolumn = "no"
          end,
        },
      },

      unlist_buffers = {
        {
          event = "FileType",
          desc = "Unlist quickfist buffers",
          callback = function(args)
            local bo = vim.bo[args.buf]
            if config.q_close_windows.filetypes[bo.filetype] then bo.buflisted = false end
          end,
        },
      },
    })
  end,
}
