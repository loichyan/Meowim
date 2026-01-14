-- Hacks to improve UI when `cmdheight = 0`.
---@diagnostic disable: duplicate-set-field

-- Show statusline when typing in cmdline.
do
  local cmdline_was_hidden = nil
  local auto_cmdheight = function(ev)
    if ev.event == 'CmdlineEnter' then
      if vim.o.cmdheight ~= 0 then return end
      vim.o.cmdheight = 1
      cmdline_was_hidden = true
    elseif cmdline_was_hidden then
      -- Suppress statusline redrawing when typing in cmdline.
      vim.o.cmdheight = 0
      cmdline_was_hidden = false
    end
  end

  Meow.autocmd('meowim.config.polish', {
    {
      event = { 'CmdlineEnter', 'CmdlineLeave' },
      desc = 'Show statusline when in cmdline',
      callback = auto_cmdheight,
    },
  })
end

-- If there are prompts when waiting for input, show the cmdline before really
-- displaying them. This method should work with most mini modules.
do
  local is_prompting, was_hidden
  local wrap_echo = function(echo, ...)
    if is_prompting and vim.o.cmdheight == 0 then
      was_hidden = true
      vim.o.cmdheight = 1
      vim.cmd('redraw')
    end
    return echo(...)
  end
  local wrap_getchar = function(getchar, ...)
    is_prompting = true
    local ok, res = pcall(getchar, ...)
    is_prompting = false

    if was_hidden then vim.o.cmdheight = 0 end
    return not ok and error(res) or res
  end

  local wrap_fn = Meowim.utils.wrap_fn
  vim.api.nvim_echo = wrap_fn(vim.api.nvim_echo, wrap_echo)
  vim.fn.getchar = wrap_fn(vim.fn.getchar, wrap_getchar)
  vim.fn.getcharstr = wrap_fn(vim.fn.getcharstr, wrap_getchar)
end

-- `input()`-like functions always display a prompt during execution,
-- hence the hack is much easier.
do
  local wrap_input = function(input, ...)
    local was_hidden = vim.o.cmdheight == 0
    if was_hidden then vim.o.cmdheight = 1 end
    local ok, res = pcall(input, ...)

    if was_hidden then vim.o.cmdheight = 0 end
    return not ok and error(res) or res
  end

  local wrap_fn = Meowim.utils.wrap_fn
  vim.fn.input = wrap_fn(vim.fn.input, wrap_input)
  vim.fn.inputlist = wrap_fn(vim.fn.inputlist, wrap_input)
  vim.fn.inputsecret = wrap_fn(vim.fn.inputsecret, wrap_input)
  vim.fn.confirm = wrap_fn(vim.fn.confirm, wrap_input)
end
