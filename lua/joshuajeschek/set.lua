-- luacheck: globals vim
vim.opt.mouse = ''
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.cmdheight = 0

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 50

-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append("c")

vim.opt.colorcolumn = "100"

vim.g.mapleader = " "

vim.g.loaded_perl_provider = false

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 25

vim.g.copilot_no_tab_map = true
vim.g.copilot_filetypes = {
  ["*"] = false,
  ["python"] = true,
  ["javascript"] = true,
  ["typescript"] = true,
  ["typescriptreact"] = true,
  ["htmldjango"] = true,
  ["yaml"] = true,
  ["sh"] = true,
  ["cs"] = true,
  ["po"] = true,
  -- ["tex"] = true,
}

-- trailing whitespaces
-- vim.fn.matchadd('errorMsg', [[\s\+$]])

vim.opt.guifont = 'CaskaydiaCove Nerd Font Mono:h15'
