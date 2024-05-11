return {
  "goolord/alpha-nvim",
  cmd = "Alpha",

  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local autocmd = opts.autocmds

        autocmd.alpha_autostart = {
          {
            event = "VimEnter",
            desc = "Start Alpha when vim is opened without arguments",
            once = true,
            callback = function()
              if vim.fn.argc() > 0 then return end
              require("lazy").load { plugins = { "alpha-nvim" } }
              require("alpha").start(true)
              vim.schedule(function() vim.cmd.doautocmd "FileType" end)
            end,
          },
        }

        autocmd.alpha_settings = {
          {
            event = { "User", "BufWinEnter" },
            desc = "Disable status, tablines, and cmdheight for Alpha",
            callback = function(ev)
              local before = vim.g.before_alpha
              local keys = { "showtabline", "laststatus", "cmdheight" }

              if
                not before
                and (
                  (ev.event == "User" and ev.file == "AlphaReady")
                  or (ev.event == "BufWinEnter" and vim.bo[ev.buf].filetype == "alpha")
                )
              then
                before = {}
                for _, k in ipairs(keys) do
                  before[k] = vim.opt[k]:get()
                  vim.opt[k] = 0
                end
                vim.g.before_alpha = before
              elseif
                before
                and ev.event == "BufWinEnter"
                and vim.bo[ev.buf].buftype ~= "nofile"
              then
                for _, k in ipairs(keys) do
                  vim.opt[k] = before[k]
                end
                vim.g.before_alpha = nil
              end
            end,
          },
        }
      end,
    },
  },

  opts = function()
    local dashboard, icon = require "alpha.themes.dashboard", require("astroui").get_icon

    ---@param lhs string Shortcut string of a button mapping
    ---@param rhs function|string? Righthand side of the mapping
    ---@param icon string Icon of the button
    ---@param desc string Text description of the button
    ---@param map_opts table? Additional options to create the mappings
    ---@diagnostic disable-next-line: redefined-local
    dashboard.button = function(lhs, rhs, icon, desc, map_opts)
      local default_opts = {
        noremap = true,
        silent = true,
        nowait = true,
        desc = desc,
      }
      map_opts = (map_opts and vim.tbl_extend("force", default_opts, map_opts)) or default_opts

      return {
        type = "button",
        val = icon .. "  " .. desc,
        on_press = function()
          local key = vim.api.nvim_replace_termcodes(lhs .. "<Ignore>", true, false, true)
          vim.api.nvim_feedkeys(key, "t", false)
        end,
        opts = {
          position = "center",
          shortcut = lhs,
          cursor = -2,
          width = 36,
          align_shortcut = "right",
          hl = "DashboardCenter",
          hl_shortcut = "DashboardShortcut",
          keymap = { "n", lhs, rhs, map_opts },
        },
      }
    end

    -- header
    -- credit: https://github.com/MaximilianLloyd/ascii.nvim/blob/c1a315e/lua/ascii/text/neovim.lua#L224-L235
    dashboard.section.header.val = {
      [[                                                                     ]],
      [[       ████ ██████           █████      ██                     ]],
      [[      ███████████             █████                             ]],
      [[      █████████ ███████████████████ ███   ███████████   ]],
      [[     █████████  ███    █████████████ █████ ██████████████   ]],
      [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
      [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
      [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
    }
    dashboard.section.header.opts.hl = "DashboardHeader"

    -- body
    local common = require "deltavim.mappings.common"
    local telescope = require "deltavim.mappings.telescope"
    local resession = require "deltavim.mappings.resession"
    local lazy = require "deltavim.mappings.lazy"
    dashboard.section.buttons.val = {
      dashboard.button("n", common.new_file[1], icon "FileNew", "New File"),
      dashboard.button("o", telescope.find_recent_files[1], icon "DefaultFile", "Recents"),
      dashboard.button("r", resession.load_dir_cwd[1], icon "Refresh", "Last Session"),
      dashboard.button("f", telescope.find_files[1], icon "Search", "Files"),
      dashboard.button("g", telescope.find_words[1], icon "WordFile", "Words"),
      dashboard.button("b", telescope.find_marks[1], icon "Bookmarks", "Bookmarks"),
      dashboard.button("p", lazy.show_status[1], icon "Package", "Packages"),
      dashboard.button("q", common.quit[1], icon "Exit", "Quit"),
    }

    -- footer
    dashboard.section.footer.val = { "Hello, NeoVim!" }
    dashboard.section.footer.opts.hl = "DashboardFooter"

    -- layout
    dashboard.config.layout = {
      { type = "padding", val = 7 },
      dashboard.section.header,
      { type = "padding", val = 5 },
      dashboard.section.buttons,
      { type = "padding", val = 3 },
      dashboard.section.footer,
    }

    dashboard.config.opts.noautocmd = true -- manually fire the FileType event
    return dashboard
  end,

  config = function(_, opts)
    require("alpha").setup(opts.config)

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      desc = "Add Alpha dashboard footer",
      once = true,
      callback = function()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
        opts.section.footer.val = {
          "NeoVim loaded "
            .. stats.loaded
            .. "/"
            .. stats.count
            .. " plugins  in "
            .. ms
            .. "ms",
        }
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
