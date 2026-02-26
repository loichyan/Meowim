---@type MeoSpec
local Spec = { 'stevearc/conform.nvim', event = 'LazyFile' }

Spec.config = function()
  require('conform').setup({
    default_format_opts = {
      timeout_ms = 3000,
      async = false,
      quiet = false,
      lsp_format = 'fallback',
    },
    formatters = {
      injected = { options = { ignore_errors = true } },
    },
    formatters_by_ft = {
      ['-'] = { 'trim_whitespaces', lsp_format = 'prefer' },
      lua = { 'stylua' },
    },
  })

  Meow.autocmd('meowim.plugins.conform', {
    {
      event = 'BufWritePre',
      desc = 'Format on save',
      callback = function(ev)
        if not Meowim.utils.is_toggle_on('autoformat_disable', ev.buf) then
          require('mini.trailspace').trim()
          require('conform').format()
        end
      end,
    },
  })
end

return Spec
