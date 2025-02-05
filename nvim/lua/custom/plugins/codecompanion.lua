local M = {
    {
        'olimorris/codecompanion.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
        },
        ---Initialize any hooks into codecompanion events
        ---@param _ LazyPlugin
        init = function(_)
            require('custom.plugins.codecompanion.hooks'):init()
        end,
        opts = {
            strategies = {
                chat = {
                    adapter = 'deepseek',
                },
            },
            adapters = {
                llama3 = function()
                    return require('codecompanion.adapters').extend('ollama', {
                        name = 'llama3',
                        schema = {
                            model = {
                                default = 'llama3:latest',
                            },
                        },
                    })
                end,
                deepseek14b = function()
                    return require('codecompanion.adapters').extend('ollama', {
                        name = 'deepseek14b',
                        schema = {
                            model = {
                                default = 'deepseek-r1:14b',
                            },
                        },
                    })
                end,
                deepseek = function()
                    return require('codecompanion.adapters').extend('ollama', {
                        name = 'deepseek',
                        schema = {
                            model = {
                                default = 'deepseek-r1:7b',
                            },
                        },
                    })
                end,
            },
        },
    },
}

return M
