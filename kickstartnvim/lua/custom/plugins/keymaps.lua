-- Setup to use netrw
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = 'Open Files' })
vim.keymap.set('n', '<leader>f', function()
    require('conform').format { async = true }
end, { desc = '[F]ormat file' })
return {}
