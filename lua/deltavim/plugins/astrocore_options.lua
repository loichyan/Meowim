---@type LazyPluginSpec
return {
  "AstroNvim/astrocore",
  ---@param opts AstroCoreOpts
  opts = function(_, opts)
    local utils = require "deltavim.utils"

    local g = {}
    g.markdown_recommended_style = 0 -- fix markdown indentation settings

    ---@diagnostic disable-next-line: inject-field
    if not vim.t.bufs then vim.t.bufs = vim.api.nvim_list_bufs() end

    local opt = {}
    opt.backspace = utils.concat(vim.opt.backspace:get(), { "nostop" }) -- don't stop backspace at insert
    opt.breakindent = true -- wrap indent to match  line start
    opt.clipboard = "unnamed" -- connection to the system clipboard
    opt.cmdheight = 0 -- hide command line unless needed
    opt.completeopt = { "menu", "menuone", "noselect" } -- Options for insert mode completion
    opt.conceallevel = 3 -- hide * markup for bold and italic
    opt.confirm = true -- raise a dialog asking if you wish to save the current file(s)
    opt.copyindent = true -- copy the previous indentation on autoindenting
    opt.cursorline = true -- highlight the text line of the cursor
    opt.diffopt = utils.concat(vim.opt.diffopt:get(), { "algorithm:histogram", "linematch:60" }) -- enable linematch diff algorithm
    opt.expandtab = true -- enable the use of space in tab
    opt.fillchars = {
      foldopen = "",
      foldclose = "",
      fold = " ",
      foldsep = " ",
      diff = "╱",
      eob = " ",
    }
    opt.foldcolumn = "1" -- show foldcolumn
    opt.foldenable = true -- enable fold for nvim-ufo
    opt.foldlevel = 99 -- set high foldlevel for nvim-ufo
    opt.foldlevelstart = 99 -- start with all code unfolded
    opt.formatoptions = "jcroqlnvt" -- tcqj
    opt.grepformat = "%f:%l:%c:%m"
    opt.ignorecase = true -- case insensitive searching
    opt.inccommand = "nosplit" -- preview incremental substitute
    opt.infercase = true -- infer cases in keyword completion
    opt.laststatus = 3 -- global statusline
    opt.linebreak = true -- wrap lines at 'breakat'
    opt.list = true -- Show some invisible characters (tabs...
    opt.mouse = "a" -- enable mouse support
    opt.number = true -- show numberline
    opt.preserveindent = true -- preserve indent structure as much as possible
    opt.pumblend = 10 -- Popup blend
    opt.pumheight = 10 -- height of the pop up menu
    opt.relativenumber = true -- show relative numberline
    opt.scrolloff = 4 -- Lines of context
    opt.shiftround = true -- Round indent
    opt.shiftwidth = 0 -- number of space inserted for indentation
    opt.shortmess = utils.merge(vim.opt.shortmess:get(), { s = true, I = true }) -- disable search count wrap and startup messages
    opt.showmode = false -- disable showing modes in command line
    opt.showtabline = 2 -- always display tabline
    opt.sidescrolloff = 8 -- Columns of context
    opt.signcolumn = "yes" -- always show the sign column
    opt.smartcase = true -- case sensitive searching
    opt.smartindent = true -- Insert indents automatically
    opt.spelllang = { "en" }
    opt.splitbelow = true -- splitting a new window below the current one
    opt.splitkeep = "screen"
    opt.splitright = true -- splitting a new window at the right of the current one
    opt.tabstop = 2 -- number of space in a tab
    opt.termguicolors = true -- enable 24-bit RGB color in the TUI
    opt.timeoutlen = 500 -- shorten key timeout length a little bit for which-key
    opt.title = true -- set terminal title to the filename and path
    opt.undofile = true -- enable persistent undo
    opt.undolevels = 10000
    opt.updatetime = 300 -- length of time to wait before triggering the plugin
    opt.viewoptions = vim.tbl_filter(
      function(val) return val ~= "curdir" end,
      vim.opt.viewoptions:get()
    )
    opt.virtualedit = "block" -- allow going past end of line in visual block mode
    opt.wildmode = "longest:full,full" -- command-line completion mode
    opt.winminwidth = 5 -- Minimum window width
    opt.wrap = false -- disable wrapping of lines longer than the width of window
    opt.writebackup = false -- disable making a backup before overwriting a file

    if vim.fn.executable "rg" == 1 then opt.grepprg = "rg ,--vimgrep" end

    opts.options = { opt = opt, g = g }
  end,
}
