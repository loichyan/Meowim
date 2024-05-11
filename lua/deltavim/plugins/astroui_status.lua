return {
  "AstroNvim/astroui",
  opts = function(_, opts)
    local sign_handlers = {}

    -- gitsigns handlers
    local gitsigns_handler = function(_)
      local ok, gitsigns = pcall(require, "gitsigns")
      if ok then vim.schedule(gitsigns.preview_hunk) end
    end
    for _, sign in ipairs { "Todeltavimlete", "Untracked", "Add", "Change", "Changedelete", "Delete" } do
      sign_handlers["GitSigns" .. sign] = gitsigns_handler
    end
    sign_handlers["gitsigns_extmark_signs_"] = gitsigns_handler

    -- diagnostic handlers
    local diagnostics_handler = function(args)
      if args.mods:find "c" then
        vim.schedule(vim.lsp.buf.code_action)
      else
        vim.schedule(vim.diagnostic.open_float)
      end
    end
    for _, sign in ipairs { "Error", "Hint", "Info", "Warn" } do
      sign_handlers["DiagnosticSign" .. sign] = diagnostics_handler
    end

    opts.status = {
      sidebar_titles = {
        ["neo-tree"] = "Explorer",
        ["aerial"] = "Symbols",
      },
      modes = {
        ["n"] = { "NORMAL", "normal" },
        ["no"] = { "OP", "normal" },
        ["nov"] = { "OP", "normal" },
        ["noV"] = { "OP", "normal" },
        ["no"] = { "OP", "normal" },
        ["niI"] = { "NORMAL", "normal" },
        ["niR"] = { "NORMAL", "normal" },
        ["niV"] = { "NORMAL", "normal" },
        ["i"] = { "INSERT", "insert" },
        ["ic"] = { "INSERT", "insert" },
        ["ix"] = { "INSERT", "insert" },
        ["t"] = { "TERM", "terminal" },
        ["nt"] = { "TERM", "terminal" },
        ["v"] = { "VISUAL", "visual" },
        ["vs"] = { "VISUAL", "visual" },
        ["V"] = { "LINES", "visual" },
        ["Vs"] = { "LINES", "visual" },
        [""] = { "BLOCK", "visual" },
        ["s"] = { "BLOCK", "visual" },
        ["R"] = { "REPLACE", "replace" },
        ["Rc"] = { "REPLACE", "replace" },
        ["Rx"] = { "REPLACE", "replace" },
        ["Rv"] = { "V-REPLACE", "replace" },
        ["s"] = { "SELECT", "visual" },
        ["S"] = { "SELECT", "visual" },
        [""] = { "BLOCK", "visual" },
        ["c"] = { "COMMAND", "command" },
        ["cv"] = { "COMMAND", "command" },
        ["ce"] = { "COMMAND", "command" },
        ["r"] = { "PROMPT", "inactive" },
        ["rm"] = { "MORE", "inactive" },
        ["r?"] = { "CONFIRM", "inactive" },
        ["!"] = { "SHELL", "inactive" },
        ["null"] = { "null", "inactive" },
      },
      separators = {
        none = { "", "" },
        breadcrumbs = "  ",
        path = "  ",
        left = { "", "" },
        right = { "", "" },
        tab = { "", "" },
      },
      attributes = {
        mode = { bold = true },
        buffer_active = { bold = true, italic = true },
        buffer_picker = { bold = true },
        sidebar_title = { bold = true },
      },
      icon_highlights = {
        file_icon = {
          tabline = function(self) return self.is_active or self.is_visible end,
          statusline = false,
        },
      },
      sign_handlers = sign_handlers,
      setup_colors = function()
        local astroui, utils = require "astroui", require "deltavim.utils"
        local status, config = require "astroui.status", assert(astroui.config.status)
        local error_hl = { fg = "red", bg = "red" }

        local function hlgroup(name, fallback)
          return astroui.get_hlgroup(name, fallback or error_hl)
        end

        local function lualine_hl(name, mode, fallback)
          local hl = hlgroup(name, {})
          if not hl.bg then hl.bg = status.hl.lualine_mode(mode, fallback.fg) end
          return hl
        end

        local Comment = hlgroup "Comment"
        local Error = hlgroup "Error"
        local Function = hlgroup "Function"
        local Keyword = hlgroup "Keyword"
        local Normal = hlgroup "Normal"
        local Number = hlgroup "Number"
        local StatusLine = hlgroup "StatusLine"
        local String = hlgroup "String"
        local TabLine = hlgroup "TabLine"
        local TabLineFill = hlgroup "TabLineFill"
        local TabLineSel = hlgroup "TabLineSel"
        local TypeDef = hlgroup "TypeDef"
        local Visual = hlgroup "Visual"
        local WinBar = hlgroup "WinBar"
        local WinBarNC = hlgroup "WinBarNC"

        local GitSignsAdd = hlgroup "GitSignsAdd"
        local GitSignsChange = hlgroup "GitSignsChange"
        local GitSignsDelete = hlgroup "GitSignsDelete"

        local DiagnosticError = hlgroup "DiagnosticError"
        local DiagnosticWarn = hlgroup "DiagnosticWarn"
        local DiagnosticInfo = hlgroup "DiagnosticInfo"
        local DiagnosticHint = hlgroup "DiagnosticHint"

        local HeirlineNormal = lualine_hl("HeirlineNormal", "normal", Function)
        local HeirlineInsert = lualine_hl("HeirlineInsert", "insert", String)
        local HeirlineReplace = lualine_hl("HeirlineReplace", "replace", Number)
        local HeirlineVisual = lualine_hl("HeirlineVisual", "visual", Keyword)
        local HeirlineCommand = lualine_hl("HeirlineCommand", "command", TypeDef)
        local HeirlineTerminal = lualine_hl("HeirlineTerminal", "terminal", Function)
        local HeirlineInactive = lualine_hl("HeirlineInactive", "inactive", String)
        local HeirlineButton = hlgroup("HeirlineButton", Visual)
        local HeirlineText = hlgroup("HeirlineText", Comment)

        local colors = {
          -- bufferline
          buffer_fg = TabLine.fg,
          buffer_bg = Normal.bg,
          buffer_path_fg = TabLine.fg,
          buffer_close_fg = TabLine.fg,

          buffer_active_fg = Normal.fg,
          buffer_active_bg = Normal.bg,
          buffer_active_path_fg = TabLine.fg,
          buffer_active_close_fg = Error.fg,

          buffer_visible_fg = Normal.fg,
          buffer_visible_bg = Normal.bg,
          buffer_visible_path_fg = TabLine.fg,
          buffer_visible_close_fg = Error.fg,

          buffer_overflow_fg = Normal.fg,
          buffer_overflow_bg = TabLineFill.bg,

          buffer_picker_fg = Error.fg,

          sidebar_title_fg = Normal.fg,
          sidebar_title_bg = TabLine.bg,

          -- tabline
          tabline_fg = TabLineFill.fg,
          tabline_bg = TabLineFill.bg,

          tab_fg = TabLine.fg,
          tab_bg = TabLine.bg,

          tab_active_fg = TabLineSel.fg,
          tab_active_bg = TabLineSel.bg,

          tab_close_fg = Error.fg,
          tab_close_bg = TabLineFill.bg,

          -- winbar
          winbar_fg = WinBar.fg,
          winbar_bg = WinBar.bg,
          winbarnc_fg = WinBarNC.fg,
          winbarnc_bg = WinBarNC.bg,

          -- statusline
          fg = StatusLine.fg,
          bg = StatusLine.bg,

          mode_fg = StatusLine.bg,
          button_fg = HeirlineButton.fg,
          button_bg = HeirlineButton.bg,

          normal = HeirlineNormal.bg,
          insert = HeirlineInsert.bg,
          visual = HeirlineVisual.bg,
          replace = HeirlineReplace.bg,
          command = HeirlineCommand.bg,
          terminal = HeirlineTerminal.bg,
          inactive = HeirlineInactive.bg,

          git_added = GitSignsAdd.fg,
          git_changed = GitSignsChange.fg,
          git_removed = GitSignsDelete.fg,

          diag_ERROR = DiagnosticError.fg,
          diag_WARN = DiagnosticWarn.fg,
          diag_INFO = DiagnosticInfo.fg,
          diag_HINT = DiagnosticHint.fg,

          scrollbar = TypeDef.fg,
          nav_icon_bg = String.fg,
          folder_icon_bg = Error.fg,
          virtual_env_icon_bg = Function.fg,
        }

        -- statusline button componments
        for _, c in ipairs {
          "file_info",
          "git_branch",
          "nav",
          "virtual_env",
        } do
          colors[c .. "_fg"] = colors.button_fg
        end
        -- statusline text componments
        for _, c in ipairs {
          "git_diff",
          "cmd_info",
          "lsp",
          "diagnostics",
          "treesitter",
        } do
          colors[c .. "_fg"] = HeirlineText.fg
          colors[c .. "_bg"] = colors.bg
        end

        -- load user defined colors
        local user_colors = config.colors
        if type(user_colors) == "table" then
          utils.merge(colors, user_colors)
        elseif type(user_colors) == "function" then
          colors = user_colors(colors)
        end

        return colors
      end,
    }
  end,
}
