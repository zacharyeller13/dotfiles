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
                    adapter = 'llama3',
                },
                inline = {
                    adapter = 'codellama',
                },
            },
            adapters = {
                codellama = function()
                    return require('codecompanion.adapters').extend('ollama', {
                        name = 'codellama',
                        formatted_name = 'CodeLlama',
                        schema = {
                            model = {
                                default = 'codellama:13b',
                            },
                            num_ctx = {
                                default = 8192,
                            },
                        },
                    })
                end,
                llama3 = function()
                    return require('codecompanion.adapters').extend('ollama', {
                        name = 'llama3',
                        formatted_name = 'Llama 3',
                        schema = {
                            model = {
                                default = 'llama3:latest',
                            },
                            num_ctx = {
                                default = 8192,
                            },
                        },
                    })
                end,
                deepseek = function()
                    return require('codecompanion.adapters').extend('ollama', {
                        name = 'deepseek',
                        formatted_name = 'Deepseek-Coder',
                        schema = {
                            model = {
                                default = 'deepseek-coder:6.7b',
                            },
                            num_ctx = {
                                default = 8192,
                            },
                        },
                    })
                end,
            },
        },
    },
}

return M
