local sql_config = { language = 'tsql', tabWidth = 4, keywordCase = 'upper' }

return {
    { -- Autoformat
        'stevearc/conform.nvim',
        ---@module "conform"
        ---@type conform.setupOpts
        opts = {
            -- log_level = vim.log.levels.DEBUG,
            notify_on_error = true,
            format_on_save = function(bufnr)
                local ignore_filetypes = { 'sql' }
                if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
                    return
                end
                return { timeout_ms = 500, lsp_fallback = true }
            end,
            formatters_by_ft = {
                lua = { 'stylua' },
                -- Conform can also run multiple formatters sequentially
                python = { 'ruff_format', 'isort', 'black' },
                -- csharp
                cs = { lsp_format = 'prefer' },
                -- You can use a sub-list to tell conform to run *until* a formatter
                -- is found.
                -- javascript = { { "prettierd", "prettier" } },
                sql = { 'sql_formatter' },
                xml = { 'xmlformatter' },
            },
            formatters = {
                sql_formatter = {
                    prepend_args = { '--config', vim.json.encode(sql_config) },
                },
            },
        },
    },
}
