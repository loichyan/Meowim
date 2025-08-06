----------------------
--- COMMON KEYMAPS ---
----------------------

local H = {}

---Close other buffers.
---@param dir integer -1: close all left, 0: close all others, 1: close all right
function H.buffer_close_others(dir)
  local curr = vim.api.nvim_get_current_buf()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if curr == bufnr then
      if dir < 0 then break end
      dir = 0
    elseif vim.bo[bufnr].buflisted and dir <= 0 then
      require("mini.bufremove").delete(bufnr)
    end
  end
end

function H.clear_ui()
  vim.cmd("noh")
  require("quicker").close()
  require("mini.snippets").session.stop()
end

function H.gitexec(...)
  Meow.load("mini.git")
  vim.cmd.Git(...)
end

---@param key string
---@param global boolean
function H.toggle(key, global) require("meowim.utils").toggle(key, global) end

function H.toggle_conceal() vim.wo.conceallevel = 2 - vim.wo.conceallevel end

---@param scope "cursor"|"buffer"
function H.apply_hunk(scope)
  if scope == "cursor" then
    return require("mini.diff").operator("apply") .. "<Cmd>lua MiniDiff.textobject()<CR>"
  else
    require("mini.diff").do_hunks(0, "apply")
  end
end

-- stylua: ignore
Meow.keymap({
  -- Common mappings
  { "<Esc>", "<Cmd>noh<CR>",              desc = "Clear highlights"       },
  { "<C-c>", function() H.clear_ui() end, desc = "Clear trivial UI items" },

  -- Toggles
  { "<LocalLeader>k", function() H.toggle("minicompletion_disable", false) end, desc = "Toggle completion"          },
  { "<LocalLeader>K", function() H.toggle("minicompletion_disable", true) end,  desc = "Toggle completion globally" },
  { "<LocalLeader>f", function() H.toggle("autoformat_disabled", false) end,    desc = "Toggle autoformat"          },
  { "<LocalLeader>F", function() H.toggle("autoformat_disabled", true) end,     desc = "Toggle autoformat globally" },
  { "<LocalLeader>q", function() require("quicker").toggle() end,               desc = "Toggle quickfix"            },
  { "<LocalLeader>v", function() H.toggle_conceal() end,                        desc = "Toggle conceal"             },

  -- Buffers/Tabs/Windows
  { "<Leader>n",  "<Cmd>enew<CR>",                                   desc = "New buffer"           },
  { "<Leader>N",  "<Cmd>tabnew<CR>",                                 desc = "New tab"              },
  { "<Leader>-",  "<Cmd>split<CR>",                                  desc = "Split horizontal"     },
  { "<Leader>\\", "<Cmd>vsplit<CR>",                                 desc = "Split vertical"       },
  { "<Leader>m",  function() require("mini.misc").zoom() end,        desc = "Zoom current buffer"  },
  { "<Leader>w",  function() require("mini.bufremove").delete() end, desc = "Close current buffer" },
  { "<Leader>W",  "<Cmd>close<CR>",                                  desc = "Close current window" },
  { "<Leader>Q",  "<Cmd>tabclose<CR>",                               desc = "Close current tab"    },

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

  { "<Leader>bh", function() H.buffer_close_others(-1) end, desc = "Close left buffers"   },
  { "<Leader>bl", function() H.buffer_close_others( 1) end, desc = "Close right buffers"  },
  { "<Leader>bo", function() H.buffer_close_others( 0) end, desc = "Close other buffers"  },

  -- Sessions
  { "<Leader>qq",  "<Cmd>quitall<CR>",                                       desc = "Quit Neovim"              },
  { "<Leader>qr",  function() require("meowim.utils").session_restore() end, desc = "Restore current session"  },
  { "<Leader>qR",  function() require("mini.sessions").select("read") end,   desc = "Restore selected session" },
  { "<Leader>qs",  function() require("meowim.utils").session_save() end,    desc = "Save current session"     },
  { "<Leader>qS",  function() require("mini.sessions").select("write") end,  desc = "Save selected session"    },
  { "<Leader>qd",  function() require("meowim.utils").session_delete() end,  desc = "Delete current session"   },
  { "<Leader>qD",  function() require("mini.sessions").select("delete") end, desc = "Delete selected session"  },
  { "<Leader>qQ",  "<Cmd>let g:minisessions_disable=v:true | quitall<CR>",   desc = "Quit Neovim quietly"      },

  -- Git
  { "<Leader>gb", "<Plug>(git-conflict-both)",                              desc = "Accept both changes"     },
  { "<Leader>gB", "<Plug>(git-conflict-none)",                              desc = "Accept base changes"     },
  { "<Leader>gc", "<Plug>(git-conflict-ours)",                              desc = "Accept current changes"  },
  { "<Leader>gi", "<Plug>(git-conflict-theirs)",                            desc = "Accept incoming changes" },

  { "<Leader>gd", function() require("mini.diff").toggle_overlay(0) end,    desc = "Show buffer changes overlay"           },
  { "<Leader>gD", function() H.gitexec("diff", "HEAD", "--", "%") end,      desc = "Show buffer changes diff"              },
  { "<Leader>gf", function() H.pick("git_conflicts") end,                   desc = "Pick Git conflicts"                    },
  { "<Leader>gh", function() H.pick("git_hunks")   end,                     desc = "Pick buffer hunks"                     },
  { "<Leader>gH", function() H.pick("git_commits") end,                     desc = "Pick Git commits"                      },
  { "<Leader>gl", function() require("mini.git").show_at_cursor() end,      desc = "Show cursor info", mode = { "n", "x" } },
  { "<Leader>gL", function() H.gitexec("log", "-p", "--", "%") end,         desc = "Show buffer history"                   },
  { "<Leader>gs", function() return H.apply_hunk("cursor") end,             desc = "State cursor hunks", expr = true       },
  { "<Leader>gS", function() return H.apply_hunk("buffer") end,             desc = "State buffer hunks", expr = true       },
})

-----------------------------
--- PICKERS & DIAGNOSTICS ---
-----------------------------

---@param dir "forward"|"backward"
---@param fallback string
function H.jump_quickfix(dir, fallback)
  if require("quicker").is_open() then
    require("mini.bracketed").quickfix(dir)
  else
    fallback = vim.api.nvim_replace_termcodes(fallback, true, false, true)
    vim.api.nvim_feedkeys(fallback, "n", false)
  end
end

---@param dir "forward"|"backward"|"first"|"last"
---@param severity vim.diagnostic.Severity?
function H.jump_diagnostic(dir, severity)
  require("mini.bracketed").diagnostic(dir, { severity = severity })
end

function H.pick_quickfix()
  require("quicker").close()
  require("mini.pick").registry.list({ scope = "quickfix" })
end

---@param scope "all"|"current"
---@param severity vim.diagnostic.Severity?
function H.pick_diagnostics(scope, severity)
  require("mini.pick").registry.diagnostic({
    scope = scope,
    get_opts = { severity = severity },
  })
end

---@param scope "all"|"current"
---@param tool? "rg"|"git"|"ast-grep"
function H.pick_lgrep(scope, tool)
  local globs = scope == "current" and { vim.fn.expand("%") } or nil
  if tool == "ast-grep" then
    require("mini.pick").registry.ast_grep_live({ globs = globs })
  else
    require("mini.pick").registry.grep_live({ tool = tool, globs = globs })
  end
end

---@param scope "all"|"current"
---@param tool? "rg"|"git"|"ast-grep"
function H.grep_word(scope, tool)
  local globs = scope == "current" and { vim.fn.expand("%") } or nil
  local pattern = vim.fn.expand("<cword>")
  if tool == "ast-grep" then
    require("mini.pick").registry.ast_grep({ pattern = pattern, globs = globs })
  else
    require("mini.pick").registry.grep({ tool = tool, pattern = pattern, globs = globs })
  end
end

---@param picker string
---@param opts? table
function H.pick(picker, opts) require("mini.pick").registry[picker](opts) end

-- stylua: ignore
Meow.keymap({
  -- Diagnostics
  { "<C-l>", function() vim.diagnostic.open_float() end,          desc = "Show current diagnostic" },
  { "<C-p>", function() H.jump_quickfix("backward", "<C-p>") end, desc = "Quickfix backward"       },
  { "<C-n>", function() H.jump_quickfix("forward", "<C-n>") end,  desc = "Quickfix forward"        },

  { "[d", function() H.jump_diagnostic("backward") end,           desc = "Diagnostic backward" },
  { "[D", function() H.jump_diagnostic("first") end,              desc = "Diagnostic first"    },
  { "]d", function() H.jump_diagnostic("forward") end,            desc = "Diagnostic forward"  },
  { "]D", function() H.jump_diagnostic("last") end,               desc = "Diagnostic last"     },
  { "[w", function() H.jump_diagnostic("backward", "WARN") end,   desc = "Warning backward"    },
  { "[W", function() H.jump_diagnostic("first",    "WARN") end,   desc = "Warning first"       },
  { "]w", function() H.jump_diagnostic("forward",  "WARN") end,   desc = "Warning forward"     },
  { "]W", function() H.jump_diagnostic("last",     "WARN") end,   desc = "Warning last"        },
  { "[e", function() H.jump_diagnostic("backward", "ERROR") end,  desc = "Error backward"      },
  { "[E", function() H.jump_diagnostic("first",    "ERROR") end,  desc = "Error first"         },
  { "]e", function() H.jump_diagnostic("forward",  "ERROR") end,  desc = "Error forward"       },
  { "]E", function() H.jump_diagnostic("last",     "ERROR") end,  desc = "Error last"          },

  { "<Leader>ld", function() H.pick_diagnostics("current") end,          desc = "Pick document diagnostics"  },
  { "<Leader>lD", function() H.pick_diagnostics("all") end,              desc = "Pick workspace diagnostics" },
  { "<Leader>lw", function() H.pick_diagnostics("current", "WARN") end,  desc = "Pick document warnings"     },
  { "<Leader>lW", function() H.pick_diagnostics("all",     "WARN") end,  desc = "Pick workspace warnings"    },
  { "<Leader>le", function() H.pick_diagnostics("current", "ERROR") end, desc = "Pick document errors"       },
  { "<Leader>lE", function() H.pick_diagnostics("all",     "ERROR") end, desc = "Pick workspace errors"      },

  -- Pickers
  { "<C-q>",            function() H.pick_quickfix() end,                  desc = "Pick quickfix"            },
  { "<Leader><Leader>", function() H.pick("smart_files") end,              desc = "Pick files"               },

  { "<Leader>'", function() H.pick("marks") end,                           desc = "Pick marks"               },
  { '<Leader>"', function() H.pick("registers") end,                       desc = "Pick registers"           },
  { "<Leader>,", function() H.pick("buffers") end,                         desc = "Pick buffers"             },
  { "<Leader>:", function() H.pick("history", { scope = "cmd" }) end,      desc = "Pick command history"     },
  { "<Leader>F", function() H.pick("resume") end,                          desc = "Resume picker"            },

  { "<Leader>fb", function() H.pick("buffers") end,                        desc = "Pick buffers"             },
  { "<Leader>fc", function() H.pick("commands") end,                       desc = "Pick commands"            },
  { "<Leader>fC", function() H.pick("autocmds") end,                       desc = "Pick autocommands"        },
  { "<Leader>ff", function() H.pick("smart_files") end,                    desc = "Pick files"               },
  { "<Leader>fF", function() H.pick("smart_files", { hidden = true }) end, desc = "Pick all files"           },
  { "<Leader>fg", function() H.pick_lgrep("current") end,                  desc = "Grep current buffer"      },
  { "<Leader>fG", function() H.pick_lgrep("all") end,                      desc = "Grep workspace files"     },
  { "<Leader>fh", function() H.pick("help") end,                           desc = "Pick helptags"            },
  { "<Leader>fk", function() H.pick("keymaps") end,                        desc = "Pick keymaps"             },
  { "<Leader>fm", function() H.pick("marks") end,                          desc = "Pick marks"               },
  { "<Leader>fn", function() H.pick("notify") end,                         desc = "Pick notifications"       },
  { "<Leader>fo", function() H.pick("oldfiles") end,                       desc = "Pick recent files"        },
  { "<Leader>fq", function() H.pick("list", { scope = "quickfix" }) end,   desc = "Pick quickfix"            },
  { "<Leader>fs", function() H.pick_lgrep("current", "ast-grep") end,      desc = "Ast-grep current buffer"  },
  { "<Leader>fS", function() H.pick_lgrep("all", "ast-grep") end,          desc = "Ast-grep workspace files" },
  { "<Leader>ft", function() H.pick("todo", { scope = "current" }) end,    desc = "Pick buffer TODOs"        },
  { "<Leader>fT", function() H.pick("todo", { scope = "all" }) end,        desc = "Pick workspace TODOs"     },
  { "<Leader>fu", function() H.pick("hl_groups") end,                      desc = "Pick highlights"          },
  { "<Leader>fU", function() H.pick("colorschemes") end,                   desc = "Pick colorschemes"        },
  { "<Leader>fr", function() H.pick("resume") end,                         desc = "Resume picker"            },
  { "<Leader>fR", function() H.pick("registers") end,                      desc = "Pick registers"           },
  { "<Leader>fw", function() H.grep_word("current", "ast-grep") end,       desc = "Grep buffer <cword>"      },
  { "<Leader>fW", function() H.grep_word("all", "ast-grep") end,           desc = "Grep workspace <cword>"   },
})

require("meowim.config.keymaps_lsp")
