local M = {}
M.__index = {}

---Returns true if the table contains a key
---@generic T : any
---@param tbl table<T,any>
---@param key T
---@return boolean
M.contains_key = function(tbl, key)
    for k, _ in pairs(tbl) do
        if key == k then
            return true
        end
    end
    return false
end

return M
