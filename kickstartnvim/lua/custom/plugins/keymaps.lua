-- Setup to use netrw
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)
vim.keymap.set('n', '<leader>f', function()
    require('conform').format { async = true }
end, {})
return {}
