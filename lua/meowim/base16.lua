local Base16 = {}

---Whether to enable transparent background in the default customization.
Base16.transparent = false

---The default options used to setup mini.base16.
---@type table
Base16.options = {
  use_cterm = false,
  plugins = {
    default = false,
    ["nvim-mini/mini.nvim"] = true,
  },
}

---@class meowim.base16.options
---Name to identify this colorscheme.
---@field name string
---Variant of this colorscheme.
---@field variant? "dark"|"light"
---Lightness adjustment to create bright colors. May be an absolute value
---greater than 1 or a relative percentage less than 1.0.
---@field bright? number
---Base16 palette.
---@field palette table<string,string>

---Apply a customized mini.base16 colorscheme.
---@param opts meowim.base16.options
function Base16.setup(opts)
  local suffix = opts.variant and "-" .. opts.variant or ""
  require("meowim.utils").cached_colorscheme({
    name = opts.name .. suffix,
    cache_token = not vim.env["MEO_DISABLE_CACHE"] and require("meowim.cache_token") or nil,
    setup = function()
      require("mini.base16").setup(
        vim.tbl_extend("force", Base16.options, { palette = opts.palette })
      )
      local minicolors = require("mini.colors").get_colorscheme()
      minicolors = Base16.colors_customizations(opts, minicolors)
      return minicolors:apply()
    end,
  })
  vim.g.colors_name = opts.name
end

---Some opinionated customizations on mini.base16.
---@param opts meowim.base16.options
---@param colors table
---@return table
function Base16.colors_customizations(opts, colors)
  if Base16.transparent then colors = colors:add_transparency() end

  local is_dark = opts.variant ~= "light"
  local lighten = function(color, delta)
    return require("meowim.utils").lighten(color, is_dark and delta or -delta)
  end
  local palette = opts.palette
  local get = function(name)
    return colors.groups[name] --[[@as vim.api.keyset.highlight]]
  end

  -- Use undercurl for diagnostics
  for _, kind in ipairs({ "Ok", "Hint", "Info", "Warn", "Error" }) do
    local hl = get("DiagnosticUnderline" .. kind)
    hl.underline = false
    hl.undercurl = true
  end

  -- Use yellow color for diagnostics.
  get("DiagnosticWarn").fg = palette.base0A
  get("DiagnosticFloatingWarn").fg = palette.base0A
  get("DiagnosticUnderlineWarn").sp = palette.base0A

  -- Transparent highlights
  ---@type string[]
  local transparents = {
    "TabLineFill",
    "StatusLine",
    "StatusLineTerm",
    "StatusLineNC",
    "StatusLineTermNC",

    "CursorLineNr",
    "CursorLineSign",
    "LineNr",
    "LineNrAbove",
    "LineNrBelow",
    "SignColumn",

    "WinSeparator",
    "ErrorMsg",
  }
  for _, name in ipairs(transparents) do
    colors.groups[name].bg = nil
  end

  -- TODO: report inconsistent higroups to mini.base16
  -- Highlight overrides
  -- stylua: ignore
  ---@type table<string,vim.api.keyset.highlight>
  local overrides = {
    ["FloatTitle"]               = { fg = get("Title").fg, bg= palette.base01 },

    ["DiffAdd"]                  = { fg = palette.base05, bg = lighten(palette.base0B, -0.41) },
    ["DiffDelete"]               = { fg = palette.base05, bg = lighten(palette.base08, -0.41) },
    ["DiffText"]                 = { fg = palette.base05, bg = lighten(palette.base0E, -0.41) },
    ["DiffTextAdd"]              = { fg = palette.base05, bg = lighten(palette.base0B, -0.41) },
    ["DiffChange"]               = { bg = palette.base02                                      },

    ["GitConflictCurrent"]       = { fg = palette.base05, bg = lighten(palette.base0D, -0.41) },
    ["GitConflictCurrentLabel"]  = { fg = palette.base05, bg = lighten(palette.base0D, -0.31) },
    ["GitConflictAncestor"]      = { fg = palette.base05, bg = lighten(palette.base0E, -0.41) },
    ["GitConflictAncestorLabel"] = { fg = palette.base05, bg = lighten(palette.base0E, -0.31) },
    ["GitConflictIncoming"]      = { fg = palette.base05, bg = lighten(palette.base0B, -0.41) },
    ["GitConflictIncomingLabel"] = { fg = palette.base05, bg = lighten(palette.base0B, -0.31) },

    ["MiniIndentscopeSymbol"]    = { fg = palette.base04 },
    ["MiniIndentscopeSymbolOff"] = { fg = palette.base04 },
  }
  for name, hl in pairs(overrides) do
    colors.groups[name] = hl
  end

  local bright = opts.bright or 0.05
  -- stylua: ignore
  colors.terminal = {
    [0]  =         palette.base02,
    [1]  =         palette.base08,
    [2]  =         palette.base0B,
    [3]  =         palette.base0A,
    [4]  =         palette.base0D,
    [5]  =         palette.base0E,
    [6]  =         palette.base0C,
    [7]  =         palette.base05,

    [8]  =         palette.base03,
    [9]  = lighten(palette.base08, bright),
    [10] = lighten(palette.base0B, bright),
    [11] = lighten(palette.base0A, bright),
    [12] = lighten(palette.base0D, bright),
    [13] = lighten(palette.base0E, bright),
    [14] = lighten(palette.base0C, bright),
    [15] =         palette.base07,
  }

  return colors
end

return Base16
