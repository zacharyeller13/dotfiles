return {
    -- Compability with nvim-cmp sources
    {
        'saghen/blink.compat',
        version = '*',
        lazy = true,
        opts = {},
    },
    {
        'saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        dependencies = {
            'rafamadriz/friendly-snippets',
            {
                -- Inserted from nvim-cmp from Kickstart
                'L3MON4D3/LuaSnip',
                version = '2.*',
                dependencies = { 'rafamadriz/friendly-snippets' },
                build = (function()
                    -- Build Step is needed for regex support in snippets
                    -- This step is not supported in many windows environments
                    -- Remove the below condition to re-enable on windows
                    if vim.fn.has('win32') == 1 or vim.fn.executable('make') == 0 then
                        return
                    end
                    return 'make install_jsregexp'
                end)(),
            },
            { 'MattiasMTS/cmp-dbee', ft = 'sql', opts = {} },
        },

        -- use a release tag to download pre-built binaries
        version = '*',
        -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        opts = {
            keymap = { preset = 'default' },

            appearance = {
                -- Sets the fallback highlight groups to nvim-cmp's highlight groups
                -- Useful for when your theme doesn't support blink.cmp
                -- will be removed in a future release
                use_nvim_cmp_as_default = true,
                -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono',
            },

            snippets = { preset = 'luasnip' },

            -- default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, via `opts_extend`
            sources = {
                default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer', 'markdown' },

                per_filetype = {
                    sql = { 'dbee', 'buffer' },
                },

                -- Needed to setup lazydev as an available provider
                providers = {
                    lazydev = {
                        name = 'LazyDev',
                        module = 'lazydev.integrations.blink',
                        score_offset = 100,
                    },
                    markdown = {
                        name = 'RenderMarkdown',
                        module = 'render-markdown.integ.blink',
                        fallbacks = { 'lsp' },
                    },
                    dbee = { name = 'cmp-dbee', module = 'blink.compat.source' },
                },

                -- optionally disable cmdline completions
                -- cmdline = {},
            },

            -- experimental signature help support
            signature = { enabled = true },
            completion = {
                menu = {
                    draw = {
                        columns = {
                            { 'kind_icon', gap = 1, 'kind' },
                            { 'label', 'label_description', gap = 1 },
                            { 'source_name' },
                        },
                    },
                },
            },
        },

        -- Need this so we can require the luasnip lazy loading
        config = function(_, opts)
            local luasnip = require('luasnip')
            luasnip.config.setup {}
            -- We have to require this for friendly snippets to load
            require('luasnip.loaders.from_vscode').lazy_load()

            require('blink.cmp').setup(opts)
        end,
    },
}
