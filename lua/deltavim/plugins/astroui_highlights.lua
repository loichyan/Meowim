return {
  "AstroNvim/astroui",
  opts = function(_, opts)
    opts.highlights = {
      init = function()
        local hlgroup, lspkind = require("astroui").get_hlgroup, require "deltavim.lspkind"

        local Error = hlgroup("Error").fg
        local Normal = hlgroup "Normal"
        local NormalFloat = hlgroup "NormalFloat"
        local String = hlgroup("String").fg

        local fg, bg = Normal.fg, Normal.bg
        local bg_alt = hlgroup("Visual").bg

        local highlights = {
          -- NvChad style telescope theme
          -- credit: https://github.com/AstroNvim/astrocommunity/blob/23d141b/lua/astrocommunity/recipes/telescope-nvchad-theme/init.lua#L21-L32
          TelescopeBorder = { fg = bg_alt, bg = bg },
          TelescopeNormal = { bg = bg },
          TelescopePreviewBorder = { fg = bg, bg = bg },
          TelescopePreviewNormal = { bg = bg },
          TelescopePreviewTitle = { fg = bg, bg = String },
          TelescopePromptBorder = { fg = bg_alt, bg = bg_alt },
          TelescopePromptNormal = { fg = fg, bg = bg_alt },
          TelescopePromptPrefix = { fg = Error, bg = bg_alt },
          TelescopePromptTitle = { fg = bg, bg = Error },
          TelescopeResultsBorder = { fg = bg, bg = bg },
          TelescopeResultsNormal = { bg = bg },
          TelescopeResultsTitle = { fg = bg, bg = bg },
        }

        -- Atom style completion menu
        -- credit: https://github.com/NvChad/base46/blob/adb64a6/lua/base46/integrations/cmp.lua#L100-L108
        for kind, _ in pairs(lspkind) do
          local hlname = "CmpItemKind" .. kind
          local hl = hlgroup(hlname)
          hl.bg = hl.fg
          hl.fg = NormalFloat.bg
          highlights[hlname] = hl
        end

        return highlights
      end,
    }
  end,
}
