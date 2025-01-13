local map = vim.keymap.set
local opts = { noremap = true, silent = true, buffer = true, desc = 'Markdown TOC' }

map('n', '<leader>md', vim.cmd.Mtoc, opts)

opts = vim.tbl_extend('force', opts, { desc = 'Replace [TOC]' })
map('n', '<leader>toc', function()
    -- TOC probably never more than 10 lines down
    local lines = vim.api.nvim_buf_get_lines(0, 0, 10, false)

    for key, value in pairs(lines) do
        -- print(key, value)
        if value == '[toc]' then
            vim.api.nvim_buf_set_lines(0, key - 1, key, false, { '<!-- mtoc-start -->', '<!-- mtoc-end -->' })
            vim.cmd.Mtoc()
            -- Early return a little bit
            return
        end
    end
end, opts)
