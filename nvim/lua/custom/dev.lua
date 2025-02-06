local M = {}

---@type vim.SystemObj
local job

M.start = function()
    ---@param out vim.SystemCompleted
    local on_exit = function(out)
        vim.print(out.code)
        vim.print(out.signal)
    end
    job = vim.system({ 'ollama', 'serve' }, {}, on_exit)
end

vim.api.nvim_create_autocmd('VimLeavePre', {
    group = vim.api.nvim_create_augroup('OllamaCmds', { clear = true }),
    callback = function(ev)
        if job then
            job:kill(9)
            vim.print(job)
        end
    end,
    desc = 'Kills `ollama serve` command before exiting vim',
})

return M
