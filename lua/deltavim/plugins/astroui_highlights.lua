---@type LazyPluginSpec
return {
  "astroui",
  ---@param opts AstroUIOpts
  opts = function(_, opts)
    opts.highlights = {
      init = function()
        local hlgroup = require("astroui").get_hlgroup

        local Error = hlgroup("Error").fg
        local NormalFloat = hlgroup "NormalFloat"
        local String = hlgroup("String").fg

        local fg, bg = NormalFloat.fg, NormalFloat.bg
        local bg_alt = hlgroup("Visual").bg

        local highlights = {
          -- NvChad style telescope theme
          -- Credit: https://github.com/AstroNvim/astrocommunity/blob/23d141b/lua/astrocommunity/recipes/telescope-nvchad-theme/init.lua#L21-L32
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
        -- Credit: https://github.com/NvChad/base46/blob/adb64a6/lua/base46/integrations/cmp.lua#L100-L108
        local miniicon = require "mini.icons"
        for kind, _ in pairs(require "deltavim.lspkind") do
          local _, hlname = miniicon.get("lsp", kind)
          local hl = hlgroup(hlname)
          highlights["CmpItemKind" .. kind] = { bg = hl.fg, fg = NormalFloat.bg }
        end

        return highlights
      end,
    }
  end,
}
