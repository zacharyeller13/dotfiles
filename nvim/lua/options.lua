-- See `:help vim.opt` and `:help option-list`
local set = vim.opt

vim.g.joplin_token = '4c3a329846c9ea4ba2e84a551f3a377ec96e44ff9bdeac5d867596978e20d11c13ea884d60141e21ab915cb01d1112f0643a6918b0be92717a86139a53175ded'

-- Make line numbers default
set.number = true
-- Relative line numbers
set.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
set.mouse = 'a'

-- Don't show the mode, since it's already in status line
set.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
--  Must have a clipboard installed - I am using `xclip`
set.clipboard = 'unnamedplus'

-- Enable break indent
set.breakindent = true

-- Save undo history
set.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
set.ignorecase = true
set.smartcase = true

-- Keep signcolumn on by default
set.signcolumn = 'yes'

-- Decrease update time
set.updatetime = 250
set.timeoutlen = 300

-- Configure how new splits should be opened
set.splitright = true
set.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
set.list = true
set.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
set.inccommand = 'split'

-- Show which line your cursor is on
set.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
set.scrolloff = 10

-- Tabstops
set.expandtab = true
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4

-- Color Column for line lengths
set.colorcolumn = '80'
