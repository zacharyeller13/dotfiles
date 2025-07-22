local M = {}

---Returns true if the table contains a key
---@param tbl table
---@param key any
---@return boolean
M.tbl_contains_key = function(tbl, key)
    for k, _ in pairs(tbl) do
        if key == k then
            return true
        end
    end
    return false
end

---Returns true if the list contains a table w/a specific key, value pair
---@param list table[]
---@param key any
---@param value any
---@return boolean
M.list_contains = function(list, key, value)
    for _, tbl in ipairs(list) do
        if tbl[key] == value then
            return true
        end
    end
    return false
end

return M
