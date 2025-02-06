---@class CodeCompanionState
---@field job? vim.SystemObj Currently active ollama server session if one exists
local M = { job = nil }

---Start ollama server
function M:start()
    ---@param out vim.SystemCompleted
    local on_exit = function(out)
        vim.print(out.code)
        vim.print(out.signal)
    end
    self.job = vim.system({ 'ollama', 'serve' }, {}, on_exit)
end

function M:init()
    local group = vim.api.nvim_create_augroup('CodeCompanionHooks', {})
    -- Needs to be 'User' since it is a plugin-defined autocmd
    vim.api.nvim_create_autocmd({ 'User' }, {
        pattern = 'CodeCompanionChatOpened',
        group = group,
        callback = function(ev)
            if not self.job then
                vim.print(ev)
                self:start()
            else
                vim.print('ollama process: ' .. self.job.pid)
            end
        end,
    })

    -- Kill the server if it's running when we leave Vim
    vim.api.nvim_create_autocmd('VimLeavePre', {
        group = group,
        callback = function(ev)
            if self.job then
                self.job:kill(2)
                vim.print('Killed ollama server: ' .. self.job.pid)
            end
        end,
        desc = 'Kills `ollama serve` command before exiting vim',
    })
end

return M
