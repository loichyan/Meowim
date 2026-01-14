local trivial_files = {
  ['checkhealth'] = true,
  ['diff'] = true,
  ['fzf'] = true,
  ['git'] = true,
  ['help'] = true,
  ['lspinfo'] = true,
  ['man'] = true,
  ['nofile'] = true,
  ['notify'] = true,
  ['qf'] = true,
  ['query'] = true,
  ['quickfix'] = true,
  ['startuptime'] = true,
  ['vim'] = true,
}
local rulers = {
  ['*'] = 80,
  ['git'] = 72,
  ['gitcommit'] = 72,
}

Meow.autocmd('meowim.config.autocmds', {
  {
    event = 'LspAttach',
    desc = 'Setup LSP related options and keymaps',
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if not client then return end
      require('meowim.config.keymaps_lsp').setup(ev.buf, client)
    end,
  },

  {
    event = 'FileType',
    desc = 'Tweak trivial buffers',
    callback = function(ev)
      if not trivial_files[ev.match] then return end
      vim.bo.buflisted = false
      vim.b.miniindentscope_disable = true
      vim.keymap.set('n', 'q', '<Cmd>lua Meowim.utils.try_close()<CR>', {
        buffer = ev.buf,
        desc = 'Close current buffer',
      })
    end,
  },

  {
    event = 'FileType',
    desc = 'Configure rulers',
    callback = function(ev)
      local ft = ev.match
      if vim.bo.buftype ~= '' or trivial_files[ft] then return end
      local width = rulers[ft] or rulers['*']
      vim.opt_local.colorcolumn:append({ width })
      vim.bo.textwidth = width
      if ft == 'markdown' then vim.opt_local.wrap = true end
    end,
  },

  {
    event = 'FileType',
    pattern = 'gitcommit',
    desc = 'Improve experience when editing gitcommit',
    callback = function(ev)
      vim.keymap.set('n', '<C-y>', '<Cmd>x<CR>', { buffer = ev.buf, desc = 'Confirm editing' })
    end,
  },

  -- See <https://stackoverflow.com/a/6728687>
  {
    event = 'FileType',
    pattern = 'qf',
    desc = 'Move quickfix window to very bottom',
    command = 'wincmd J',
  },

  -- Taken from <https://github.com/neovim/neovim/issues/12374#issuecomment-2121867087>
  {
    event = 'ModeChanged',
    pattern = { 'n:no', 'no:n' },
    desc = 'Preserve cursor position when yanking',
    callback = function(ev)
      if vim.v.operator == 'y' then
        if ev.match == 'n:no' then
          vim.b.yank_last_pos = vim.fn.getpos('.')
        else
          if vim.b.yank_last_pos then
            vim.fn.setpos('.', vim.b.yank_last_pos)
            vim.b.yank_last_pos = nil
          end
        end
      end
    end,
  },

  {
    event = 'BufWritePre',
    desc = 'Ensure directories before writing',
    callback = function(ev)
      if not vim.bo[ev.buf].buflisted then return end
      vim.fn.mkdir(vim.fn.fnamemodify(ev.file, ':h'), 'p')
    end,
  },
})
