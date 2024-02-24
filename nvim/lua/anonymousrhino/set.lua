-- Put our leader key here as it fits with all the other "sets"
vim.g.mapleader = " "

-- Line Numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Spaces > tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

-- Long-running undos
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Stop keeping search terms highlighted
vim.opt.hlsearch = false
-- But incremental search is handy
vim.opt.incsearch = true

vim.opt.termguicolors = true

-- Never less than 8 characters at the end of the screen
vim.opt.scrolloff = 8

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"








