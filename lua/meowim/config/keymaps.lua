---Close other buffers.
---@param dir integer -1: close all left, 0: close all others, 1: close all right
local buffer_close_others = function(dir)
    local curr = vim.api.nvim_get_current_buf()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if curr == bufnr then
            if dir < 0 then
                break
            end
            dir = 0
        elseif vim.bo[bufnr].buflisted and dir <= 0 then
            require("mini.bufremove").delete(bufnr)
        end
    end
end

---@param dir "forward"|"backward"|"first"|"last"
---@param severity vim.diagnostic.Severity?
local diagnostic_jump = function(dir, severity)
    require("mini.bracketed").diagnostic(dir, { severity = severity })
end

---@param scope "all"|"current"
---@param severity vim.diagnostic.Severity?
local pick_diagnostics = function(scope, severity)
    require("mini.pick").registry.diagnostic({
        scope = scope,
        get_opts = { severity = severity },
    })
end

---@param dir "forward"|"backward"
---@param fallback string
local make_qf_jump = function(dir, fallback)
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
    { "<Esc>", "<Cmd>noh<CR>", desc = "Clear highlights" },
    { "<C-c>", super_clear,    desc = "Clear trivial items" },

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

    { "[t",    "<Cmd>tabprevious<CR>",                                      desc = "Tab previous"     },
    { "[T",    "<Cmd>tabfirst<CR>",                                         desc = "Tab first"        },
    { "]t",    "<Cmd>tabnext<CR>",                                          desc = "Tab next"         },
    { "]T",    "<Cmd>tablast<CR>",                                          desc = "Tab last"         },
    { "[b",    function() require("mini.bracketed").buffer("backward") end, desc = "Buffer right"     },
    { "[B",    function() require("mini.bracketed").buffer("first") end,    desc = "Buffer rightmost" },
    { "]b",    function() require("mini.bracketed").buffer("forward") end,  desc = "Buffer left"      },
    { "]B",    function() require("mini.bracketed").buffer("last") end,     desc = "Buffer leftmost"  },
    { "<S-h>", function() require("mini.bracketed").buffer("backward") end, desc = "Buffer left"      },
    { "<S-l>", function() require("mini.bracketed").buffer("forward") end,  desc = "Buffer right"     },

    { "<Leader>bh", function() buffer_close_others(-1) end, desc = "Close left buffers"   },
    { "<Leader>bl", function() buffer_close_others( 1) end, desc = "Close right buffers"  },
    { "<Leader>bo", function() buffer_close_others( 0) end, desc = "Close other buffers"  },

    -- quickfixes/diagnostics
    { "<C-l>", function() vim.diagnostic.open_float() end, desc = "Show current diagnostic" },
    { "<C-p>", make_qf_jump("backward", "<C-p>"),          desc = "Quickfix backward"       },
    { "<C-n>", make_qf_jump("forward", "<C-n>"),           desc = "Quickfix forward"        },

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

    { "<Leader>ld", function() pick_diagnostics("current") end,          desc = "Pick document diagnostics"  },
    { "<Leader>lD", function() pick_diagnostics("all") end,              desc = "Pick workspace diagnostics" },
    { "<Leader>lw", function() pick_diagnostics("current", "WARN") end,  desc = "Pick document warnings"     },
    { "<Leader>lW", function() pick_diagnostics("all", "WARN") end,      desc = "Pick workspace warnings"    },
    { "<Leader>le", function() pick_diagnostics("current", "ERROR") end, desc = "Pick document errors"       },
    { "<Leader>lE", function() pick_diagnostics("all", "ERROR") end,     desc = "Pick workspace errors"      },

    -- pickers
    { "<C-q>",     function() require("mini.pick").registry.list({ scope = "quickfix" }) end, desc = "Pick quickfix"        },
    { "<Leader>'", function() require("mini.pick").registry.marks() end,                    desc = "Pick marks"           },
    { '<Leader>"', function() require("mini.pick").registry.registers() end,                desc = "Pick registers"       },
    { "<Leader>,", function() require("mini.pick").registry.buffers() end,                  desc = "Pick buffers"         },
    { "<Leader>:", function() require("mini.pick").registry.history({ scope = "cmd" }) end, desc = "Pick command history" },
    { "<Leader>F", function() require("mini.pick").registry.resume() end,                   desc = "Resume picker"        },
    { "<Leader><Leader>", function() require("meowim.utils").pick_files(false) end,         desc = "Pick files"           },

    { "<Leader>fb", function() require("mini.pick").registry.buffers() end,                           desc = "Pick buffers"         },
    { "<Leader>fc", function() require("mini.pick").registry.commands() end,                          desc = "Pick commands"        },
    -- TODO: add autocommands picker
    -- { "<Leader>fC", function() require("mini.pick").registry.autocmds() end,                          desc = "Pick autocommands"    },
    { "<Leader>ff", function() require("meowim.utils").pick_files(false) end,                         desc = "Pick files"           },
    { "<Leader>fF", function() require("meowim.utils").pick_files(true) end,                          desc = "Pick all files"       },
    { "<Leader>fg", function() require("mini.pick").registry.grep_live() end,                         desc = "Grep files"           },
    { "<Leader>fh", function() require("mini.pick").registry.help() end,                              desc = "Pick helptags"        },
    { "<Leader>fk", function() require("mini.pick").registry.keymaps() end,                           desc = "Pick keymaps"         },
    { "<Leader>fm", function() require("mini.pick").registry.marks() end,                             desc = "Pick marks"           },
    { "<Leader>fn", function() require("mini.pick").registry.notify() end,                            desc = "Pick notifications"   },
    { "<Leader>fo", function() require("mini.pick").registry.oldfiles() end,                          desc = "Pick recent files"    },
    { "<Leader>fq", function() require("mini.pick").registry.list({ scope = "quickfix" }) end,        desc = "Pick quickfix"        },
    { "<Leader>ft", function() require("meowim.utils").pick_todo("current", { "TODO", "FIXME" }) end, desc = "Pick buffer TODOs"    },
    { "<Leader>fT", function() require("meowim.utils").pick_todo("all", { "TODO", "FIXME" }) end,     desc = "Pick workspace TODOs" },
    { "<Leader>fU", function() require("mini.pick").registry.hl_groups() end,                         desc = "Grep highlights"      },
    { "<Leader>fr", function() require("mini.pick").builtin.resume() end,                             desc = "Resume picker"        },
    { "<Leader>fR", function() require("mini.pick").registry.registers() end,                         desc = "Pick registers"       },

    -- git
    { "<Leader>gd", function() gitexec("diff", "HEAD", "--", "%") end,        desc = "Show buffer changes"                   },
    { "<Leader>gh", function() gitexec("log", "-p", "--", "%") end,           desc = "Show buffer history"                   },
    { "<Leader>gl", function() require("mini.git").show_at_cursor() end,      desc = "Show cursor info", mode = { "n", "x" } },
    { "<Leader>gs", function() require("mini.diff").do_hunks(0, "apply") end, desc = "State buffer hunks"                    },
})

---Lists only items of current buffer.
---@param opts vim.lsp.LocationOpts.OnList
local list_buf = function(opts)
    local bufnr = vim.api.nvim_get_current_buf()
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    opts.items = vim.tbl_filter(
        function(v) return v.bufnr == bufnr or v.filename == bufname end,
        opts.items
    )
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.fn.setqflist({}, " ", opts)
    vim.schedule(function() vim.cmd("copen") end)
end

-- stylua: ignore
vim.api.nvim_create_autocmd("LspAttach", { callback = function(ev) Meow.keyset(ev.buf, {
    { "K",   function() vim.lsp.buf.hover() end,           desc = "Show documentation"   },
    { "gd",  function() vim.lsp.buf.definition() end,      desc = "Goto definition"      },
    { "gD",  function() vim.lsp.buf.type_definition() end, desc = "Goto type definition" },

    { "<Leader>la", function() vim.lsp.buf.code_action() end,   desc = "List code actions", mode = { "n", "x" } },
    { "<Leader>lf", function() require("conform").format() end, desc = "Format",            mode = { "n", "x" } },

    { "<Leader>ln", function() vim.lsp.buf.rename() end,                               desc = "Rename" },
    { "<Leader>li", function() vim.lsp.buf.implementation({ on_list = list_buf }) end, desc = "List buffer implementations"    },
    { "<Leader>lI", function() vim.lsp.buf.implementation() end,                       desc = "List workspace implementations" },
    { "<Leader>lr", function() vim.lsp.buf.references({ includeDeclaration = false }, { on_list = list_buf }) end, desc = "List buffer references"    },
    { "<Leader>lR", function() vim.lsp.buf.references({ includeDeclaration = false }) end,                         desc = "List workspace references" },
    { "<Leader>ls", function() require('mini.pick').registry.lsp({ scope = "document_symbol" }) end,               desc = "Pick buffer symbols"    },
    { "<Leader>lS", function() require('mini.pick').registry.lsp({ scope = "workspace_symbol" }) end,              desc = "Pick workspace symbols" },
}) end, desc = "Set LSP specified keymaps" })
