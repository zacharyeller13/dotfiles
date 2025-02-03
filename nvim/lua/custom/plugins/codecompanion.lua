local M = {
    {
        'olimorris/codecompanion.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
        },
        opts = {
            strategies = {
                chat = {
                    adapter = 'ollama',
                },
            },
        },
        ---Executed when plugin loads. Has extra logic to create autocmds
        ---@param _ LazyPlugin
        ---@param opts table
        config = function(_, opts)
            require('codecompanion').setup(opts)

            ---@type vim.SystemObj
            local job = nil

            ---Starts the ollama server
            local start = function()
                ---@param out vim.SystemCompleted
                local on_exit = function(out)
                    vim.print(out.code)
                    vim.print(out.signal)
                end
                job = vim.system({ 'ollama', 'serve' }, {}, on_exit)
            end

            local group = vim.api.nvim_create_augroup('CodeCompanionHooks', {})

            -- Needs to be 'User' since it is a plugin-defined autocmd
            vim.api.nvim_create_autocmd({ 'User' }, {
                pattern = 'CodeCompanionChatOpened',
                group = group,
                callback = function(ev)
                    if not job then
                        vim.print(ev)
                        start()
                    else
                        vim.print('ollama process: ' .. job.pid)
                    end
                end,
            })

            -- Kill the server if it's running when we leave Vim
            vim.api.nvim_create_autocmd('VimLeavePre', {
                group = group,
                callback = function(ev)
                    if job then
                        job:kill(2)
                        vim.print('Killed ollama server: ' .. job.pid)
                    end
                end,
                desc = 'Kills `ollama serve` command before exiting vim',
            })
        end,
    },
}

return M
