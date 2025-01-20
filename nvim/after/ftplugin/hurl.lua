local map = vim.keymap.set
local opts = { noremap = true, silent = true, buffer = true }

map('n', '<leader>A', '<cmd>HurlRunner<CR>', { buffer = true, desc = 'Run All requests' })
map('n', '<leader>a', '<cmd>HurlRunnerAt<CR>', { buffer = true, desc = 'Run Api request' })
map('n', '<leader>te', '<cmd>HurlRunnerToEntry<CR>', { buffer = true, desc = 'Run Api request to entry' })
map('n', '<leader>tE', '<cmd>HurlRunnerToEnd<CR>', { buffer = true, desc = 'Run Api request from current entry to end' })
map('n', '<leader>tm', '<cmd>HurlToggleMode<CR>', { buffer = true, desc = 'Hurl Toggle Mode' })
map('n', '<leader>tv', '<cmd>HurlVerbose<CR>', { buffer = true, desc = 'Run Api in verbose mode' })
map('n', '<leader>tV', '<cmd>HurlVeryVerbose<CR>', { buffer = true, desc = 'Run Api in very verbose mode' })
-- Run Hurl request in visual mode
map('v', '<leader>h', ':HurlRunner<CR>', { buffer = true, desc = 'Hurl Runner' })
