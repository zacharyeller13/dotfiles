-- Setup to use netrw
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = 'Open Files' })

-- Map the Escape cmd to jj in most contexts
-- Already mapped to <C-[>
-- <C-c> is like Esc!, don't run anything like LSP
vim.keymap.set('i', 'jj', '<Escape>', { desc = 'Escape' })
vim.keymap.set('c', 'jj', '<Escape>', { desc = 'Escape' })

-- Format using conform
vim.keymap.set('n', '<leader>f', function()
    local out = require('conform').format { async = true }
    if out then
        print('Formatted!')
    end
end, { desc = '[F]ormat file' })

-- Harpoon keymaps
local harpoon = require('harpoon')
-- Calling setup is required
harpoon:setup {
    settings = {
        save_on_toggle = true,
    },
}
vim.keymap.set('n', '<leader>a', function()
    harpoon:list():add()
end, { desc = '[A]dd to Harpoon' })
vim.keymap.set('n', '<C-e>', function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end)
vim.keymap.set('n', '<C-h>', function()
    harpoon:list():select(1)
end)
vim.keymap.set('n', '<C-j>', function()
    harpoon:list():select(2)
end)
vim.keymap.set('n', '<C-k>', function()
    harpoon:list():select(3)
end)
vim.keymap.set('n', '<C-l>', function()
    harpoon:list():select(4)
end)

-- Keep the cursor in the middle when paging up/down
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
return {}
