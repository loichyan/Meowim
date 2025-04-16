---@param dir "forward"|"backward"|"first"|"last"
---@param severity vim.diagnostic.Severity?
local diagnostic_jump = function(dir, severity)
    require("mini.bracketed").diagnostic(dir, { severity = severity })
end

---@param workspace boolean
---@param severity vim.diagnostic.Severity?
local fzf_diagnostics = function(workspace, severity)
    if workspace then
        require("fzf-lua").diagnostics_workspace({ severity_only = severity })
    else
        require("fzf-lua").diagnostics_document({ severity_only = severity })
    end
end

---@param dir "forward"|"backward"
---@param fallback string
local create_smart_qf_jump = function(dir, fallback)
    fallback = vim.api.nvim_replace_termcodes(fallback, true, false, true)
    return function()
        if require("quicker").is_open() then
            require("mini.bracketed").quickfix(dir)
        else
            vim.api.nvim_feedkeys(fallback, "n", false)
        end
    end
end

local super_clear = function()
    vim.cmd("noh")
    require("quicker").close()
    require("mini.snippets").session.stop()
end

-- stylua: ignore
Meow.keyset({
    -- common mappings
    { "<Esc>", super_clear, desc = "Clear trivial items" },
    { "<C-C>", super_clear, desc = "Clear trivial items" },

    -- toggles
    { "<LocalLeader>f", require("meowim.utils").create_toggler("autoformat_disabled", false), desc = "Toggle autoformat"          },
    { "<LocalLeader>F", require("meowim.utils").create_toggler("autoformat_disabled", true),  desc = "Toggle autoformat globally" },

    -- buffers/tabs/windows
    { "<Leader>n",  "<Cmd>enew<CR>",                                   desc = "New buffer"           },
    { "<Leader>t",  "<Cmd>tabnew<CR>",                                 desc = "New tab"              },
    { "<Leader>-",  "<Cmd>split<CR>",                                  desc = "Split horizontal"     },
    { "<Leader>\\", "<Cmd>vsplit<CR>",                                 desc = "Split vertical"       },
    { "<Leader>m",  function() require("mini.misc").zoom() end,        desc = "Zoom current buffer"  },
    { "<Leader>w",  function() require("mini.bufremove").delete() end, desc = "Close current buffer" },
    { "<Leader>W",  "<Cmd>close<CR>",                                  desc = "Close current window" },
    { "<Leader>Q",  "<Cmd>tabclose<CR>",                               desc = "Close current tab"    },

    { "[t",    "<Cmd>tabprevious<CR>",                                       desc = "Tab previous"     },
    { "[T",    "<Cmd>tabfirst<CR>",                                          desc = "Tab first"        },
    { "]t",    "<Cmd>tabnext<CR>",                                           desc = "Tab next"         },
    { "]T",    "<Cmd>tablast<CR>",                                           desc = "Tab last"         },
    { "[b",    function() require("mini.bracketed").buffer("backward") end,  desc = "Buffer right"     },
    { "[B",    function() require("mini.bracketed").buffer("first") end,     desc = "Buffer rightmost" },
    { "]b",    function() require("mini.bracketed").buffer("forward") end,   desc = "Buffer left"      },
    { "]B",    function() require("mini.bracketed").buffer("last") end,      desc = "Buffer leftmost"  },
    { "<S-h>", function() require("mini.bracketed").buffer("backward") end,  desc = "Buffer left"      },
    { "<S-l>", function() require("mini.bracketed").buffer("forward") end,   desc = "Buffer right"     },

    { "<Leader>bh", function() require("meowim.utils").buffer_close_others(-1) end, desc = "Close left buffers"   },
    { "<Leader>bl", function() require("meowim.utils").buffer_close_others( 1) end, desc = "Close right buffers"  },
    { "<Leader>bo", function() require("meowim.utils").buffer_close_others( 0) end, desc = "Close other buffers"  },

    -- quickfixes/diagnostics
    { "<Leader>q", function() require("quicker").toggle() end, desc = "Toggle quickfix" },

    { "<C-L>", function() vim.diagnostic.open_float() end,    desc = "Show current diagnostic" },
    { "<C-P>", create_smart_qf_jump("backward", "<C-P>"),         desc = "Quickfix backward"       },
    { "<C-N>", create_smart_qf_jump("forward", "<C-N>"),          desc = "Quickfix forward"        },

    { "[d", function() diagnostic_jump("backward"         ) end, desc = "Diagnostic backward" },
    { "[D", function() diagnostic_jump("first"            ) end, desc = "Diagnostic first"    },
    { "]d", function() diagnostic_jump("forward"          ) end, desc = "Diagnostic forward"  },
    { "]D", function() diagnostic_jump("last"             ) end, desc = "Diagnostic last"     },
    { "[w", function() diagnostic_jump("backward", "WARN" ) end, desc = "Warning backward"    },
    { "[W", function() diagnostic_jump("first",    "WARN" ) end, desc = "Warning first"       },
    { "]w", function() diagnostic_jump("forward",  "WARN" ) end, desc = "Warning forward"     },
    { "]W", function() diagnostic_jump("last",     "WARN" ) end, desc = "Warning last"        },
    { "[e", function() diagnostic_jump("backward", "ERROR") end, desc = "Error backward"      },
    { "[E", function() diagnostic_jump("first",    "ERROR") end, desc = "Error first"         },
    { "]e", function() diagnostic_jump("forward",  "ERROR") end, desc = "Error forward"       },
    { "]E", function() diagnostic_jump("last",     "ERROR") end, desc = "Error last"          },

    { "<Leader>ld", function() fzf_diagnostics(false) end,          desc = "List document diagnostics"  },
    { "<Leader>lD", function() fzf_diagnostics(true) end,           desc = "List workspace diagnostics" },
    { "<Leader>lw", function() fzf_diagnostics(false, "WARN") end,  desc = "List document warnings"     },
    { "<Leader>lW", function() fzf_diagnostics(true, "WARN") end,   desc = "List workspace warnings"    },
    { "<Leader>le", function() fzf_diagnostics(false, "ERROR") end, desc = "List document errors"       },
    { "<Leader>lE", function() fzf_diagnostics(true, "ERROR") end,  desc = "List workspace errors"      },

    -- pickers
    { "<Leader>'",        function() require("fzf-lua").marks() end,               desc = "Find marks"     },
    { '<Leader>"',        function() require("fzf-lua").registers() end,           desc = "Find registers" },
    { "<Leader>,",        function() require("fzf-lua").buffers() end,             desc = "Find buffers"   },
    { "<Leader>F",        function() require("fzf-lua").resume() end,              desc = "Resume picker"  },
    { "<Leader><Leader>", function() require("meowim.utils").fzf_files(false) end, desc = "Find files"     },

    { "<Leader>fb", function() require("fzf-lua").buffers() end,                     desc = "Find buffers"      },
    { "<Leader>fc", function() require("fzf-lua").commands() end,                    desc = "Find commands"     },
    { "<Leader>fC", function() require("fzf-lua").autocmds() end,                    desc = "Find autocommands" },
    { "<Leader>ff", function() require("meowim.utils").fzf_files(false) end,         desc = "Find files"        },
    { "<Leader>fF", function() require("meowim.utils").fzf_files(true) end,          desc = "Find all files"    },
    { "<Leader>fg", function() require("fzf-lua").live_grep({ hidden = false }) end, desc = "Grep files"        },
    { "<Leader>fG", function() require("fzf-lua").live_grep({ hidden = true }) end,  desc = "Grep all files"    },
    { "<Leader>fh", function() require("fzf-lua").helptags() end,                    desc = "Find helptags"     },
    { "<Leader>fH", function() require("fzf-lua").manpages() end,                    desc = "Find manpages"     },
    { "<Leader>fk", function() require("fzf-lua").keymaps() end,                     desc = "Find keymaps"      },
    { "<Leader>fm", function() require("fzf-lua").marks() end,                       desc = "Find marks"        },
    { "<Leader>fo", function() require("fzf-lua").oldfiles() end,                    desc = "Find recent files" },
    { "<Leader>fu", function() require("fzf-lua").colorschemes() end,                desc = "Grep colorschemes" },
    { "<Leader>fU", function() require("fzf-lua").highlights() end,                  desc = "Grep highlights"   },
    { "<Leader>fr", function() require("fzf-lua").resume() end,                      desc = "Resume picker"     },
    { "<Leader>fR", function() require("fzf-lua").registers() end,                   desc = "Find registers"    },

    -- git
    { "<Leader>gb", "<Plug>(git-conflict-both)",                              desc = "Accept both changes"     },
    { "<Leader>gB", "<Plug>(git-conflict-none)",                              desc = "Accept base changes"     },
    { "<Leader>gc", "<Plug>(git-conflict-ours)",                              desc = "Accept current changes"  },
    { "<Leader>gi", "<Plug>(git-conflict-theirs)",                            desc = "Accept incoming changes" },
    { "<Leader>gs", function() require("mini.diff").do_hunks(0, "apply") end, desc = "Stage buffer hunks"      },
})

-- stylua: ignore
vim.api.nvim_create_autocmd("LspAttach", { callback = function(args) Meow.keyset(args.buf, {
    { "K",   function() vim.lsp.buf.hover() end,           desc = "Show documentation"   },
    { "gd",  function() vim.lsp.buf.definition() end,      desc = "Goto definition"      },
    { "gD",  function() vim.lsp.buf.type_definition() end, desc = "Goto type definition" },

    { "<Leader>ln", function() vim.lsp.buf.rename() end,                     desc = "Rename"                },
    { "<Leader>la", function() vim.lsp.buf.code_action() end,                desc = "Show code actions"     },
    { "<Leader>lA", function() require("fzf-lua").lsp_code_actions() end,    desc = "List code actions"     },
    { "<Leader>li", function() vim.lsp.buf.implementation() end,             desc = "Show implementation"   },
    { "<Leader>lI", function() require("fzf-lua").lsp_implementations() end, desc = "List implementations"  },
    { "<Leader>lr", function() vim.lsp.buf.references() end,                 desc = "Show references"       },
    { "<Leader>lR", function() require("fzf-lua").lsp_references() end,      desc = "List references"       },
}) end, desc = "Set LSP specified keymaps" })
