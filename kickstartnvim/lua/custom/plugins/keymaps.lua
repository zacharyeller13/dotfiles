-- Setup to use netrw
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = 'Open Files' })

-- Format using conform
vim.keymap.set('n', '<leader>f', function()
    require('conform').format { async = true }
end, { desc = '[F]ormat file' })

-- Keep the cursor in the middle when paging up/down
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
return {}
