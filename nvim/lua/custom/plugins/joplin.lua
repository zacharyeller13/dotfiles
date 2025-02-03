return {
    {
        'tylerTaerak/joplin.nvim',
        enabled = false,
        config = function()
            -- Joplin
            vim.keymap.set('n', '<leader>j', vim.cmd.Joplin, { desc = 'Open [J]oplin' })
        end,
    },
}
