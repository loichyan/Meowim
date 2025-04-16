---@type MeoSpec
return {
    "mini.brackted",
    event = "VeryLazy",
    config = function()
        -- stylua: ignore
        require("mini.bracketed").setup({
            buffer     = { suffix = ""  },
            comment    = { suffix = "c" },
            conflict   = { suffix = "x" },
            diagnostic = { suffix = ""  },
            file       = { suffix = ""  },
            indent     = { suffix = "i" },
            jump       = { suffix = ""  },
            location   = { suffix = "l" },
            oldfile    = { suffix = ""  },
            quickfix   = { suffix = "q" },
            treesitter = { suffix = ""  },
            undo       = { suffix = ""  },
            window     = { suffix = ""  },
            yank       = { suffix = ""  },
        })
    end,
}
