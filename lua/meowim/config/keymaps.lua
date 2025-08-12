----------------------
--- COMMON KEYMAPS ---
----------------------

local H = require("meowim.config.keymaps_helpers")
local nx = { "n", "x" }

-- stylua: ignore
Meow.keymap({
  -- Common mappings
  { "<Esc>",               "<Cmd>noh<CR>",                                                                         desc = "Clear highlights"                  },
  { "<C-c>",               function() H.clear_ui() end,                                                            desc = "Clear trivial UI items"            },

  { "<Leader>e",           function() H.plugins.mini.files.open("buffer") end,                                     desc = "Explore buffer directory"          },
  { "<Leader>E",           function() H.plugins.mini.files.open("workspace") end,                                  desc = "Explore workspace root"            },

  -- Toggles
  { "<LocalLeader>k",      function() H.utils.toggle("minicompletion_disable", "global") end,                      desc = "Toggle completion"                 },
  { "<LocalLeader>K",      function() H.utils.toggle("minicompletion_disable", "buffer") end,                      desc = "Toggle completion globally"        },
  { "<LocalLeader>f",      function() H.utils.toggle("autoformat_disabled", "global") end,                         desc = "Toggle autoformat"                 },
  { "<LocalLeader>F",      function() H.utils.toggle("autoformat_disabled", "buffer") end,                         desc = "Toggle autoformat globally"        },
  { "<LocalLeader>q",      function() require("quicker").toggle() end,                                             desc = "Toggle quickfix"                   },
  { "<LocalLeader>v",      "<Cmd>lua vim.wo.conceallevel = 2 - vim.wo.conceallevel",                               desc = "Toggle conceallevel"               },

  -- Buffers/Tabs/Windows
  { "<Leader>n",           "<Cmd>enew<CR>",                                                                        desc = "New buffer"                        },
  { "<Leader>N",           "<Cmd>tabnew<CR>",                                                                      desc = "New tab"                           },
  { "<Leader>-",           "<Cmd>split<CR>",                                                                       desc = "Split horizontal"                  },
  { "<Leader>\\",          "<Cmd>vsplit<CR>",                                                                      desc = "Split vertical"                    },
  { "<Leader>m",           function() H.plugins.mini.misc.zoom() end,                                              desc = "Zoom current buffer"               },
  { "<Leader>w",           function() require("mini.bufremove").delete() end,                                      desc = "Close current buffer"              },
  { "<Leader>W",           "<Cmd>close<CR>",                                                                       desc = "Close current window"              },
  { "<Leader>Q",           "<Cmd>tabclose<CR>",                                                                    desc = "Close current tab"                 },

  { "[t",                  "<Cmd>tabprevious<CR>",                                                                 desc = "Tab previous"                      },
  { "[T",                  "<Cmd>tabfirst<CR>",                                                                    desc = "Tab first"                         },
  { "]t",                  "<Cmd>tabnext<CR>",                                                                     desc = "Tab next"                          },
  { "]T",                  "<Cmd>tablast<CR>",                                                                     desc = "Tab last"                          },
  { "[b",                  function() require("mini.bracketed").buffer("backward") end,                            desc = "Buffer right"                      },
  { "[B",                  function() require("mini.bracketed").buffer("first") end,                               desc = "Buffer rightmost"                  },
  { "]b",                  function() require("mini.bracketed").buffer("forward") end,                             desc = "Buffer left"                       },
  { "]B",                  function() require("mini.bracketed").buffer("last") end,                                desc = "Buffer leftmost"                   },
  { "<S-h>",               function() require("mini.bracketed").buffer("backward") end,                            desc = "Buffer left"                       },
  { "<S-l>",               function() require("mini.bracketed").buffer("forward") end,                             desc = "Buffer right"                      },

  { "<Leader>bh",          function() H.plugins.mini.bufremove.close_others("left") end,                           desc = "Close left buffers"                },
  { "<Leader>bl",          function() H.plugins.mini.bufremove.close_others("right") end,                          desc = "Close right buffers"               },
  { "<Leader>bo",          function() H.plugins.mini.bufremove.close_others("all") end,                            desc = "Close other buffers"               },

  -- Sessions
  { "<Leader>qq",          "<Cmd>quitall<CR>",                                                                     desc = "Quit Neovim"                       },
  { "<Leader>qr",          function() H.plugins.mini.sessions.restore() end,                                       desc = "Restore current session"           },
  { "<Leader>qR",          function() require("mini.sessions").select("read") end,                                 desc = "Restore selected session"          },
  { "<Leader>qs",          function() H.plugins.mini.sessions.save() end,                                          desc = "Save current session"              },
  { "<Leader>qS",          function() require("mini.sessions").select("write") end,                                desc = "Save selected session"             },
  { "<Leader>qd",          function() H.plugins.mini.sessions.delete() end,                                        desc = "Delete current session"            },
  { "<Leader>qD",          function() require("mini.sessions").select("delete") end,                               desc = "Delete selected session"           },
  { "<Leader>qQ",          "<Cmd>let g:minisessions_disable=v:true | quitall<CR>",                                 desc = "Quit Neovim quietly"               },

  -- Git
  { "<Leader>ga",          function() H.git("add", "--", "%") end,                                                 desc = "Add current file to Git"           },
  { "<Leader>gA",          function() H.git_commit("amend") end,                                                   desc = "Amend previous commit"             },
  { "<Leader>gc",          function() H.git_commit("prompt") end,                                                  desc = "Commit changes quick"              },
  { "<Leader>gC",          function() H.git_commit("edit") end,                                                    desc = "Commit changes in buffer"          },
  { "<Leader>gd",          function() require("mini.diff").toggle_overlay(0) end,                                  desc = "Show buffer diffs overlay"         },
  -- TODO: enable word diff if the 'diff' treesitter parser adds support it
  { "<Leader>gD",          function() H.git("diff", "HEAD~" .. vim.v.count) end,                                   desc = "Show workspace diffs"              },
  { "<Leader>gf",          function() H.pick("git_conflicts") end,                                                 desc = "Pick Git conflicts"                },
  { "<Leader>gg",          function() require("mini.git").show_at_cursor() end, mode = nx,                         desc = "Show cursor info"                  },
  { "<Leader>gh",          function() H.pick("git_hunks")   end,                                                   desc = "Pick buffer hunks"                 },
  { "<Leader>gH",          function() H.git("log", "-p", "--", "%") end,                                           desc = "Show buffer history"               },
  { "<Leader>gl",          function() H.pick("git_commits") end,                                                   desc = "Pick workspace commits"            },
  { "<Leader>gL",          function() H.git_show_buffer() end,                                                     desc = "Show buffer of revision"           },
  { "<Leader>gs",          function() H.pick("git_status") end,                                                    desc = "Pick Git status"                   },
  { "<Leader>gU",          function() H.git("reset", "-q", "--", "%") end,                                         desc = "Reset buffer index"                },

  -- Conflicts
  { "<Leader>ca",          "<Plug>(git-conflict-both)",                                                            desc = "Accept both changes"               },
  { "<Leader>cr",          "<Plug>(git-conflict-none)",                                                            desc = "Reject both changes"               },
  { "<Leader>cc",          "<Plug>(git-conflict-ours)",                                                            desc = "Accept current changes"            },
  { "<Leader>cC",          function() H.git("checkout", "--ours", "--", "%") end,                                  desc = "Accept current buffer changes"     },
  { "<Leader>ci",          "<Plug>(git-conflict-theirs)",                                                          desc = "Accept incoming changes"           },
  { "<Leader>cI",          function() H.git("checkout", "--theirs", "--", "%") end,                                desc = "Accept incoming buffer changes"    },

  -- Diagnostics
  { "<C-l>",               function() vim.diagnostic.open_float() end,                                             desc = "Show current diagnostic"           },
  { "<C-p>",               function() H.jump_quickfix("backward", "<C-p>") end,                                    desc = "Quickfix backward"                 },
  { "<C-n>",               function() H.jump_quickfix("forward", "<C-n>") end,                                     desc = "Quickfix forward"                  },

  { "[d",                  function() H.jump_diagnostic("backward") end,                                           desc = "Diagnostic backward"               },
  { "[D",                  function() H.jump_diagnostic("first") end,                                              desc = "Diagnostic first"                  },
  { "]d",                  function() H.jump_diagnostic("forward") end,                                            desc = "Diagnostic forward"                },
  { "]D",                  function() H.jump_diagnostic("last") end,                                               desc = "Diagnostic last"                   },
  { "[w",                  function() H.jump_diagnostic("backward", "WARN") end,                                   desc = "Warning backward"                  },
  { "[W",                  function() H.jump_diagnostic("first",    "WARN") end,                                   desc = "Warning first"                     },
  { "]w",                  function() H.jump_diagnostic("forward",  "WARN") end,                                   desc = "Warning forward"                   },
  { "]W",                  function() H.jump_diagnostic("last",     "WARN") end,                                   desc = "Warning last"                      },
  { "[e",                  function() H.jump_diagnostic("backward", "ERROR") end,                                  desc = "Error backward"                    },
  { "[E",                  function() H.jump_diagnostic("first",    "ERROR") end,                                  desc = "Error first"                       },
  { "]e",                  function() H.jump_diagnostic("forward",  "ERROR") end,                                  desc = "Error forward"                     },
  { "]E",                  function() H.jump_diagnostic("last",     "ERROR") end,                                  desc = "Error last"                        },

  { "<Leader>ld",          function() H.pick_diagnostics("current") end,                                           desc = "Pick document diagnostics"         },
  { "<Leader>lD",          function() H.pick_diagnostics("all") end,                                               desc = "Pick workspace diagnostics"        },
  { "<Leader>lw",          function() H.pick_diagnostics("current", "WARN") end,                                   desc = "Pick document warnings"            },
  { "<Leader>lW",          function() H.pick_diagnostics("all",     "WARN") end,                                   desc = "Pick workspace warnings"           },
  { "<Leader>le",          function() H.pick_diagnostics("current", "ERROR") end,                                  desc = "Pick document errors"              },
  { "<Leader>lE",          function() H.pick_diagnostics("all",     "ERROR") end,                                  desc = "Pick workspace errors"             },

  -- Pickers
  { "<C-q>",               function() H.pick_quickfix() end,                                                       desc = "Pick quickfix"                     },
  { "<Leader><Leader>",    function() H.pick("smart_files") end,                                                   desc = "Pick files"                        },

  { "<Leader>'",           function() H.pick("marks") end,                                                         desc = "Pick marks"                        },
  { '<Leader>"',           function() H.pick("registers") end,                                                     desc = "Pick registers"                    },
  { "<Leader>,",           function() H.pick("buffers") end,                                                       desc = "Pick buffers"                      },
  { "<Leader>:",           function() H.pick("history", {scope="cmd"}) end,                                        desc = "Pick command history"              },
  { "<Leader>F",           function() H.pick("resume") end,                                                        desc = "Resume picker"                     },

  { "<Leader>fb",          function() H.pick("buffers") end,                                                       desc = "Pick buffers"                      },
  { "<Leader>fc",          function() H.pick("commands") end,                                                      desc = "Pick commands"                     },
  { "<Leader>fC",          function() H.pick("autocmds") end,                                                      desc = "Pick autocommands"                 },
  { "<Leader>ff",          function() H.pick("smart_files") end,                                                   desc = "Pick files"                        },
  { "<Leader>fF",          function() H.pick("smart_files", {hidden=true}) end,                                    desc = "Pick all files"                    },
  { "<Leader>fg",          function() H.pick_lgrep("current") end,                                                 desc = "Grep current buffer"               },
  { "<Leader>fG",          function() H.pick_lgrep("all") end,                                                     desc = "Grep workspace files"              },
  { "<Leader>fh",          function() H.pick("help") end,                                                          desc = "Pick helptags"                     },
  { "<Leader>fk",          function() H.pick("keymaps") end,                                                       desc = "Pick keymaps"                      },
  { "<Leader>fm",          function() H.pick("marks") end,                                                         desc = "Pick marks"                        },
  { "<Leader>fn",          function() H.pick("notify") end,                                                        desc = "Pick notifications"                },
  { "<Leader>fo",          function() H.pick("oldfiles") end,                                                      desc = "Pick recent files"                 },
  { "<Leader>fq",          function() H.pick("list", {scope="quickfix"}) end,                                      desc = "Pick quickfix"                     },
  { "<Leader>fs",          function() H.pick_lgrep("current", {tool="ast-grep"}) end,                              desc = "Ast-grep current buffer"           },
  { "<Leader>fS",          function() H.pick_lgrep("all", {tool="ast-grep"}) end,                                  desc = "Ast-grep workspace files"          },
  { "<Leader>ft",          function() H.pick("todo", {scope="current"}) end,                                       desc = "Pick buffer TODOs"                 },
  { "<Leader>fT",          function() H.pick("todo", {scope="all"}) end,                                           desc = "Pick workspace TODOs"              },
  { "<Leader>fu",          function() H.pick("hl_groups") end,                                                     desc = "Pick highlights"                   },
  { "<Leader>fU",          function() H.pick("colorschemes") end,                                                  desc = "Pick colorschemes"                 },
  { "<Leader>fr",          function() H.pick("registers") end,                                                     desc = "Pick registers"                    },
  { "<Leader>fR",          function() H.pick("resume") end,                                                        desc = "Resume picker"                     },
  { "<Leader>fw",          function() H.pick_word("current", {tool="ast-grep"}) end,                               desc = "Grep buffer <cword>"               },
  { "<Leader>fW",          function() H.pick_word("all", {tool="ast-grep"}) end,                                   desc = "Grep workspace <cword>"            },
})

-- stylua: ignore
local lsp_keymaps = {
  { "K",                   function() vim.lsp.buf.hover() end,     has = "textDocument/hover",                     desc = "Show documentation"                },
  { "gd",                  function() H.lsp_definition() end,      has = "textDocument/definition",                desc = "Goto definition"                   },
  { "gD",                  function() H.lsp_type_definition() end, has = "textDocument/typeDefinition",            desc = "Goto type definition"              },

  { "]r",                  function() require("snacks.words").jump( vim.v.count1, true) end,                       desc = "Reference forward"                 },
  { "[r",                  function() require("snacks.words").jump(-vim.v.count1, true) end,                       desc = "Reference backward"                },

  { "<Leader>la",          function() vim.lsp.buf.code_action() end, mode = nx,                                    desc = "List code actions"                 },
  { "<Leader>lf",          function() require("conform").format() end, mode = nx,                                  desc = "Format buffer"                     },
  { "<Leader>ln",          function() vim.lsp.buf.rename() end,                                                    desc = "Rename cursor symbol"              },
  { "<Leader>li",          function() H.lsp_implementation("current") end,                                         desc = "List buffer implementations"       },
  { "<Leader>lI",          function() H.lsp_implementation("all") end,                                             desc = "List workspace implementations"    },
  { "<Leader>lr",          function() H.lsp_references("current") end,                                             desc = "List buffer references"            },
  { "<Leader>lR",          function() H.lsp_references("all") end,                                                 desc = "List workspace references"         },
  { "<Leader>ls",          function() H.pick("lsp", {scope="document_symbol"}) end,                                desc = "Pick buffer symbols"               },
  { "<Leader>lS",          function() H.pick("lsp", {scope="workspace_symbol"}) end,                               desc = "Pick workspace symbols"            },
}

Meow.autocmd("meowim.config.keymaps", {
  {
    event = "LspAttach",
    desc = "Setup LSP specified keymaps",
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if not client then return end

      local specs, bufnr = {}, ev.buf
      for _, spec in ipairs(lsp_keymaps) do
        -- Setup conditional keymaps only if the client supports it
        if spec.has and client:supports_method(spec.has, bufnr) then
          spec = vim.deepcopy(spec)
          spec.has = nil
        end
        if not spec.has then table.insert(specs, spec) end
      end
      Meow.keymap(bufnr, specs)
    end,
  },
})
