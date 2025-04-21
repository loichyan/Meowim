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

local gitexec = function(...)
    Meow.load("mini.git")
    vim.cmd.Git(...)
end

-- stylua: ignore
Meow.keyset({
    -- common mappings
    { "<Esc>", super_clear, desc = "Clear trivial items" },
    { "<C-C>", super_clear, desc = "Clear trivial items" },

    -- toggles
    { "<LocalLeader>f", require("meowim.utils").create_toggler("autoformat_disabled", false), desc = "Toggle autoformat"          },
    { "<LocalLeader>F", require("meowim.utils").create_toggler("autoformat_disabled", true),  desc = "Toggle autoformat globally" },
    { "<LocalLeader>q", function() require("quicker").toggle() end,                           desc = "Toggle quickfix"            },

    -- buffers/tabs/windows
    { "<Leader>n",  "<Cmd>enew<CR>",                                   desc = "New buffer"           },
    { "<Leader>N",  "<Cmd>tabnew<CR>",                                 desc = "New tab"              },
    { "<Leader>-",  "<Cmd>split<CR>",                                  desc = "Split horizontal"     },
    { "<Leader>\\", "<Cmd>vsplit<CR>",                                 desc = "Split vertical"       },
    { "<Leader>m",  function() require("mini.misc").zoom() end,        desc = "Zoom current buffer"  },
    { "<Leader>w",  function() require("mini.bufremove").delete() end, desc = "Close current buffer" },
    { "<Leader>W",  "<Cmd>close<CR>",                                  desc = "Close current window" },
    { "<Leader>Q",  "<Cmd>tabclose<CR>",                               desc = "Close current tab"    },

    -- sessions
    { "<Leader>qq",  "<Cmd>quitall<CR>",                                       desc = "Quit Neovim"              },
    { "<Leader>qr",  function() require("meowim.utils").session_restore() end, desc = "Restore current session"  },
    { "<Leader>qR",  function() require("mini.sessions").select("read") end,   desc = "Restore selected session" },
    { "<Leader>qs",  function() require("meowim.utils").session_save() end,    desc = "Save current session"     },
    { "<Leader>qS",  function() require("mini.sessions").select("write") end,  desc = "Save selected session"    },
    { "<Leader>qd",  function() require("meowim.utils").session_delete() end,  desc = "Delete current session"   },
    { "<Leader>qD",  function() require("mini.sessions").select("delete") end, desc = "Delete selected session"  },
    { "<Leader>qQ",  "<Cmd>let g:minisessions_disable=v:true | quitall<CR>",   desc = "Quit Neovim quietly"      },

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

    { "<Leader>ld", function() fzf_diagnostics(false) end,          desc = "Pick document diagnostics"  },
    { "<Leader>lD", function() fzf_diagnostics(true) end,           desc = "Pick workspace diagnostics" },
    { "<Leader>lw", function() fzf_diagnostics(false, "WARN") end,  desc = "Pick document warnings"     },
    { "<Leader>lW", function() fzf_diagnostics(true, "WARN") end,   desc = "Pick workspace warnings"    },
    { "<Leader>le", function() fzf_diagnostics(false, "ERROR") end, desc = "Pick document errors"       },
    { "<Leader>lE", function() fzf_diagnostics(true, "ERROR") end,  desc = "Pick workspace errors"      },

    -- pickers
    { "<Leader>'",        function() require("fzf-lua").marks() end,               desc = "Pick marks"           },
    { '<Leader>"',        function() require("fzf-lua").registers() end,           desc = "Pick registers"       },
    { "<Leader>,",        function() require("fzf-lua").buffers() end,             desc = "Pick buffers"         },
    { "<Leader>:",        function() require("fzf-lua").command_history() end,     desc = "Pick command history" },
    { "<Leader>F",        function() require("fzf-lua").resume() end,              desc = "Resume picker"        },
    { "<Leader><Leader>", function() require("meowim.utils").fzf_files(false) end, desc = "Pick files"           },

    { "<Leader>fb", function() require("fzf-lua").buffers() end,                                 desc = "Pick buffers"         },
    { "<Leader>fc", function() require("fzf-lua").commands() end,                                desc = "Pick commands"        },
    { "<Leader>fC", function() require("fzf-lua").autocmds() end,                                desc = "Pick autocommands"    },
    { "<Leader>ff", function() require("meowim.utils").fzf_files(false) end,                     desc = "Pick files"           },
    { "<Leader>fF", function() require("meowim.utils").fzf_files(true) end,                      desc = "Pick all files"       },
    { "<Leader>fg", function() require("fzf-lua").live_grep({ hidden = false }) end,             desc = "Grep files"           },
    { "<Leader>fG", function() require("fzf-lua").live_grep({ hidden = true }) end,              desc = "Grep all files"       },
    { "<Leader>fh", function() require("fzf-lua").helptags() end,                                desc = "Pick helptags"        },
    { "<Leader>fH", function() require("fzf-lua").manpages() end,                                desc = "Pick manpages"        },
    { "<Leader>fk", function() require("fzf-lua").keymaps() end,                                 desc = "Pick keymaps"         },
    { "<Leader>fm", function() require("fzf-lua").marks() end,                                   desc = "Pick marks"           },
    { "<Leader>fo", function() require("fzf-lua").oldfiles() end,                                desc = "Pick recent files"    },
    { "<Leader>fq", function() require("fzf-lua").quickfix() end,                                desc = "Pick quickfix"        },
    { "<Leader>ft", function() require("meowim.utils").fzf_todo({ "TODO", "FIXME" }, false) end, desc = "Pick buffer TODOs"    },
    { "<Leader>fT", function() require("meowim.utils").fzf_todo({ "TODO", "FIXME" }, true) end,  desc = "Pick workspace TODOs" },
    { "<Leader>fu", function() require("fzf-lua").colorschemes() end,                            desc = "Grep colorschemes"    },
    { "<Leader>fU", function() require("fzf-lua").highlights() end,                              desc = "Grep highlights"      },
    { "<Leader>fr", function() require("fzf-lua").resume() end,                                  desc = "Resume picker"        },
    { "<Leader>fR", function() require("fzf-lua").registers() end,                               desc = "Pick registers"       },

    -- git
    { "<Leader>gb", "<Plug>(git-conflict-both)",                              desc = "Accept both changes"                   },
    { "<Leader>gB", "<Plug>(git-conflict-none)",                              desc = "Accept base changes"                   },
    { "<Leader>gc", "<Plug>(git-conflict-ours)",                              desc = "Accept current changes"                },
    { "<Leader>gi", "<Plug>(git-conflict-theirs)",                            desc = "Accept incoming changes"               },
    { "<Leader>gd", function() gitexec("diff", "HEAD", "--", "%") end,        desc = "Show buffer changes"                   },
    { "<Leader>gh", function() gitexec("log", "-p", "--", "%") end,           desc = "Show buffer history"                   },
    { "<Leader>gl", function() require("mini.git").show_at_cursor() end,      desc = "Show cursor info", mode = { "n", "x" } },
    { "<Leader>gs", function() require("mini.diff").do_hunks(0, "apply") end, desc = "State buffer hunks"                    },
})

-- stylua: ignore
vim.api.nvim_create_autocmd("LspAttach", { callback = function(ev) Meow.keyset(ev.buf, {
    { "K",   function() vim.lsp.buf.hover() end,           desc = "Show documentation"   },
    { "gd",  function() vim.lsp.buf.definition() end,      desc = "Goto definition"      },
    { "gD",  function() vim.lsp.buf.type_definition() end, desc = "Goto type definition" },

    { "<Leader>la", function() vim.lsp.buf.code_action() end,                desc = "List code actions", mode = { "n", "x" } },
    { "<Leader>lA", function() require("fzf-lua").lsp_code_actions() end,    desc = "Pick code actions", mode = { "n", "x" } },
    { "<Leader>lf", function() require("conform").format() end,              desc = "Format",            mode = { "n", "x" } },

    { "<Leader>ln", function() vim.lsp.buf.rename() end,                     desc = "Rename"               },
    { "<Leader>li", function() vim.lsp.buf.implementation() end,             desc = "List implementations" },
    { "<Leader>lI", function() require("fzf-lua").lsp_implementations() end, desc = "Pick implementations" },
    { "<Leader>lr", function() vim.lsp.buf.references() end,                 desc = "List references"      },
    { "<Leader>lR", function() require("fzf-lua").lsp_references() end,      desc = "Pick references"      },
}) end, desc = "Set LSP specified keymaps" })
