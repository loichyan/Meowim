local Base16 = {}

---@class meowim.base16.options
---Name to identify this colorscheme.
---@field name string
---Variant of this colorscheme.
---@field variant? 'dark'|'light'
---Lightness adjustment to create bright colors. May be an absolute value
---greater than 1 or a relative percentage less than 1.0.
---@field bright? number
---Base16 palette.
---@field palette table<string,string>

---Whether to enable transparent background in the default customization.
Base16.transparent = false

---The default options used to setup mini.base16.
---@type table
Base16.options = {
  use_cterm = false,
  plugins = {
    default = false,
    ['nvim-mini/mini.nvim'] = true,
  },
}

---Apply a customized mini.base16 colorscheme.
---@param opts meowim.base16.options
Base16.setup = function(opts)
  local suffix = opts.variant and '-' .. opts.variant or ''
  local base16_opts = vim.tbl_extend('force', Base16.options, { palette = opts.palette })
  require('meowim.utils').cached_colorscheme({
    name = opts.name .. suffix,
    cache_token = require('meowim.cache_token'),
    setup = function()
      require('mini.base16').setup(base16_opts)
      local minicolors = require('mini.colors').get_colorscheme()
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
Base16.colors_customizations = function(opts, colors)
  local is_dark = opts.variant ~= 'light'
  local p = opts.palette

  local lighten = function(color, delta)
    return require('meowim.utils').lighten(color, is_dark and delta or -delta)
  end
  local get = function(name)
    local opts = colors.groups[name]
    if opts.link then colors.groups[name] = vim.deepcopy(colors.groups[opts.link]) end
    return colors.groups[name] --[[@as vim.api.keyset.highlight]]
  end

  -- stylua: ignore
  local diagnostic_colors = {
    ['Ok']    = p.base0B,
    ['Info']  = p.base0C,
    ['Hint']  = p.base0D,
    ['Warn']  = p.base0A,
    ['Error'] = p.base08,
  }
  for kind, color in pairs(diagnostic_colors) do
    local hl
    -- Update colors
    hl = get('Diagnostic' .. kind)
    hl.fg = color
    hl = get('DiagnosticFloating' .. kind)
    hl.fg = color
    -- Use undercurl for diagnostics
    hl = get('DiagnosticUnderline' .. kind)
    hl.sp = color
    hl.underline = false
    hl.undercurl = true
    -- Use bold text for diagnostic signs
    hl = get('DiagnosticSign' .. kind)
    hl.bg = nil
  end

  -- stylua: ignore
  local hipatter_colors = {
    ['Fixme'] = p.base08,
    ['Hack']  = p.base0E,
    ['Note']  = p.base0B,
    ['Todo']  = p.base0C,
  }
  for name, color in pairs(hipatter_colors) do
    colors.groups['MiniHipatterns' .. name] = { fg = color, bold = true }
    colors.groups['MiniHipatterns' .. name .. 'Sign'] = { fg = color }
  end

  -- TODO: report inconsistent higroups to mini.base16
  -- Highlight overrides
  -- stylua: ignore
  ---@type table<string,vim.api.keyset.highlight>
  local overrides = {
    ['BlinkCmpLabelDeprecated']  = {fg=p.base05, strikethrough=true},
    ['FloatTitle']               = {fg=get('Title').fg, bg=p.base01},
    ['FoldColumn']               = {fg=p.base03},
    ['CursorLineFold']           = {fg=p.base03},
    ['ZoomTitle']                = {fg=p.base0A, bold=true},

    ['DiffAdd']                  = {fg=p.base05, bg=lighten(p.base0B, -0.7)},
    ['DiffChange']               = {fg=p.base05, bg=lighten(p.base0E, -0.7)},
    ['DiffDelete']               = {fg=p.base05, bg=lighten(p.base08, -0.7)},
    ['DiffText']                 = {link='DiffTextChange'},
    ['DiffTextAdd']              = {fg=p.base05, bg=lighten(p.base0B, -0.4)},
    ['DiffTextChange']           = {fg=p.base05, bg=lighten(p.base0E, -0.4)},
    ['DiffTextDelete']           = {fg=p.base05, bg=lighten(p.base08, -0.4)},

    ['GitConflictIncoming']      = {link='DiffAdd'},
    ['GitConflictAncestor']      = {link='DiffChange'},
    ['GitConflictCurrent']       = {link='DiffDelete'},
    ['GitConflictIncomingLabel'] = {link='DiffTextAdd'},
    ['GitConflictAncestorLabel'] = {link='DiffTextChange'},
    ['GitConflictCurrentLabel']  = {link='DiffTextDelete'},

    ['MiniIndentscopeSymbol']    = {fg=p.base04},
    ['MiniIndentscopeSymbolOff'] = {fg=p.base04},
    ['MiniStatuslineProject']    = {fg=p.base09, bold=true},
    ['MiniStatuslineCursor']     = {fg=p.base0A},
  }
  for name, hl in pairs(overrides) do
    colors.groups[name] = hl
  end

  -- Terminal colors
  local bright = opts.bright or 0.05
  -- stylua: ignore
  colors.terminal = {
    [0]  = p.base02,
    [1]  = p.base08,
    [2]  = p.base0B,
    [3]  = p.base0A,
    [4]  = p.base0D,
    [5]  = p.base0E,
    [6]  = p.base0C,
    [7]  = p.base05,
    [8]  = p.base03,
    [9]  = lighten(p.base08, bright),
    [10] = lighten(p.base0B, bright),
    [11] = lighten(p.base0A, bright),
    [12] = lighten(p.base0D, bright),
    [13] = lighten(p.base0E, bright),
    [14] = lighten(p.base0C, bright),
    [15] = p.base07,
  }

  -- Transparent highlights
  ---@type string[]
  local transparents = {
    'TabLineFill',
    'StatusLine',
    'StatusLineTerm',
    'StatusLineNC',
    'StatusLineTermNC',
    'WinBar',
    'WinBarNC',

    'CursorLineNr',
    'CursorLineSign',
    'LineNr',
    'LineNrAbove',
    'LineNrBelow',
    'SignColumn',

    'MiniDiffSignAdd',
    'MiniDiffSignChange',
    'MiniDiffSignDelete',

    'WinSeparator',
    'ErrorMsg',
  }
  for _, name in ipairs(transparents) do
    get(name).bg = nil
  end

  if Base16.transparent then colors = colors:add_transparency() end
  return colors
end

return Base16
