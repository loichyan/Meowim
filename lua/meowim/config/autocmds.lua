local trivial_files = {
  ["checkhealth"] = true,
  ["diff"] = true,
  ["fzf"] = true,
  ["git"] = true,
  ["help"] = true,
  ["lspinfo"] = true,
  ["man"] = true,
  ["nofile"] = true,
  ["notify"] = true,
  ["qf"] = true,
  ["query"] = true,
  ["quickfix"] = true,
  ["startuptime"] = true,
  ["vim"] = true,
}
local rulers = {
  ["*"] = 80,
  ["git"] = 72,
  ["gitcommit"] = 72,
}

Meow.autocmd("meowim.config.autocmds", {
  {
    event = "FileType",
    desc = "Tweak trivial files",
    pattern = vim.tbl_keys(trivial_files),
    callback = function(ev)
      vim.b.miniindentscope_disable = true
      vim.bo.buflisted = false
      vim.keymap.set("n", "q", "<Cmd>close<CR>", { desc = "Close current window", buffer = ev.buf })
    end,
  },
  {
    event = "FileType",
    desc = "Configure rulers",
    callback = function()
      local ft = vim.bo.filetype
      if trivial_files[ft] then return end
      local width = rulers[ft] or rulers["*"]
      vim.opt_local.colorcolumn = { width }
      vim.opt_local.textwidth = width
      if ft == "markdown" then vim.opt_local.wrap = true end
    end,
  },
  -- See <https://stackoverflow.com/a/6728687>
  {
    event = "FileType",
    desc = "Move quickfix window to very bottom",
    pattern = "qf",
    command = "wincmd J",
  },
  -- Taken from <https://github.com/neovim/neovim/issues/12374#issuecomment-2121867087>
  {
    event = "ModeChanged",
    desc = "Preserve cursor position when yanking",
    pattern = { "n:no", "no:n" },
    callback = function(ev)
      if vim.v.operator == "y" then
        if ev.match == "n:no" then
          vim.b.yank_last_pos = vim.fn.getpos(".")
        else
          if vim.b.yank_last_pos then
            vim.fn.setpos(".", vim.b.yank_last_pos)
            vim.b.yank_last_pos = nil
          end
        end
      end
    end,
  },
})
