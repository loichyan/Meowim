---@module "herline.nvim"

---@type LazyPluginSpec
local Spec = {
  "rebelot/heirline.nvim",
  event = "BufEnter",

  opts = function()
    -- Credit: https://github.com/AstroNvim/astrocommunity/blob/41f7a6a/lua/astrocommunity/recipes/heirline-nvchad-statusline/init.lua#

    local status, icon = require "astroui.status", require("astroui").get_icon
    local hl, component, condition = status.hl, status.component, status.condition
    local deltavim_components = require "deltavim.stl.components"

    ---@param cond function
    local cond_not = function(cond)
      return function(...) return not cond(...) end
    end

    return {
      opts = {
        colors = require("astroui").config.status.setup_colors(),
        disable_winbar_cb = function(args)
          return not require("astrocore.buffer").is_valid(args.buf)
              or condition.buffer_matches({ buftype = { "terminal", "nofile" } }, args.buf)
        end,
      },

      -------------
      -- bufferline
      -------------

      tabline = {
        -- automatic sidebar padding
        { deltavim_components.sidebar_title() },

        status.heirline.make_buflist(component.tabline_file_info()),
        component.fill { hl = { bg = "tabline_bg" } },

        {
          -- hide tabline until there are 1+ tabs
          condition = function() return #vim.api.nvim_list_tabpages() >= 2 end,
          status.heirline.make_tablist {
            provider = status.provider.tabnr(),
            hl = function(self)
              return hl.get_attributes(status.heirline.tab_type(self, "tab"), true)
            end,
          },
          { -- close button for current tab
            provider = status.provider.close_button {
              kind = "TabClose",
              padding = { left = 1, right = 1 },
            },
            hl = hl.get_attributes("tab_close", true),
            on_click = {
              name = "heirline_tabline_close_tab_callback",
              callback = function() require("astrocore.buffer").close_tab() end,
            },
          },
        },
      },

      ---------
      -- winbar
      ---------

      winbar = {
        init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
        fallthrough = false,
        {
          condition = cond_not(condition.is_active),
          component.separated_path { hl = hl.get_attributes("winbarnc", true) },
          component.file_info {
            file_icon = { hl = hl.file_icon "winbar", padding = { left = 0 } },
            filename = {},
            filetype = false,
            file_read_only = false,
            hl = hl.get_attributes("winbarnc", true),
            surround = false,
            update = "BufEnter",
          },
        },
        component.breadcrumbs { hl = hl.get_attributes("winbar", true) },
      },

      -------------
      -- statusline
      -------------

      statusline = {
        hl = { fg = "fg", bg = "bg" },

        ------------------
        -- left components
        ------------------

        component.mode {
          mode_text = { icon = { kind = "VimIcon", padding = { right = 1 } } },
          padding = { left = 1, right = 1 },
          surround = {
            separator = "left",
            color = function() return { main = hl.mode_bg(), right = "button_bg" } end,
          },
        },

        component.file_info {
          filetype = { icon = { kind = "DefaultFile", padding = { right = 1 } } },
          filename = false,
          file_icon = false,
          file_modified = false,
          file_read_only = false,
          padding = { left = 1, right = 1 },
          surround = {
            condition = cond_not(condition.is_git_repo),
            separator = "left",
            color = { main = "button_bg" },
          },
        },

        component.git_branch {
          git_branch = { padding = false },
          padding = { left = 1, right = 1 },
          surround = {
            condition = condition.is_git_repo,
            separator = "left",
            color = { main = "button_bg" },
          },
        },

        component.git_diff {
          surround = { separator = "none" },
        },

        component.cmd_info {
          macro_recording = { padding = { left = 0, right = 1 } },
          search_count = { padding = { left = 0, right = 1 } },
          showcmd = { padding = { left = 0, right = 1 } },
          padding = { left = 1 },
          surround = { separator = "none" },
        },

        --------------------
        -- center components
        --------------------
        component.fill(),

        -------------------
        -- right components
        -------------------

        component.lsp {
          lsp_client_names = false,
          lsp_progress = { padding = false },
          padding = { right = 1 },
          surround = { separator = "none", color = "bg" },
        },
        component.diagnostics {
          padding = { right = 1 },
          surround = { separator = "none" },
        },
        component.lsp {
          lsp_client_names = { icon = { padding = { right = 1 } } },
          lsp_progress = false,
          padding = { right = 1 },
          surround = { separator = "none" },
        },

        { -- nav
          component.builder {
            { provider = icon "ScrollText" },
            padding = { right = 1 },
            hl = { fg = "mode_fg" },
            surround = { separator = "right", color = "nav_icon_bg" },
          },
          component.nav {
            percentage = false,
            ruler = { padding = false },
            scrollbar = false,
            padding = { left = 1, right = 1 },
            surround = { separator = "none", color = "button_bg" },
          },
        },

        { -- project
          component.builder {
            { provider = icon "FolderClosed" },
            hl = { fg = "mode_fg" },
            padding = { right = 1 },
            surround = {
              separator = "right",
              color = { main = "folder_icon_bg", left = "button_bg" },
            },
          },
          component.file_info {
            filename = {
              fname = function(buf) return vim.fn.getcwd(buf) end,
            },
            filetype = false,
            file_icon = false,
            file_modified = false,
            file_read_only = false,
            padding = { left = 1, right = 1 },
            surround = { condition = false, separator = "none", color = "button_bg" },
          },
        },

        { -- virtualenv
          condition = condition.has_virtual_env,
          component.builder {
            { provider = icon "Environment" },
            hl = { fg = "mode_fg" },
            padding = { right = 1 },
            surround = {
              separator = "right",
              color = { main = "virtual_env_icon_bg", left = "button_bg" },
            },
          },
          component.virtual_env {
            virtual_env = { icon = { kind = "NONE" }, padding = false },
            padding = { left = 1, right = 1 },
            surround = { condition = false, separator = "none", color = "button_bg" },
          },
        },
      },

      statuscolumn = {
        init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
        component.signcolumn(),
        component.numbercolumn(),
        component.foldcolumn(),
      },
    }
  end,

  config = function(_, opts)
    require("heirline").setup(opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = "AstroColorScheme",
      group = vim.api.nvim_create_augroup("Heirline", { clear = true }),
      desc = "Refresh heirline colors",
      callback = function() require("astroui.status.heirline").refresh_colors() end,
    })
  end,
}

return Spec
