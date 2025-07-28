local M = {}

---Check if the laptop is charging or plugged in
---@param result table the results from a Sketchybar.exec cmd
---@return boolean #if the laptop is currently charging
function M.is_charging(result)
    for _ in result:gmatch("AC Power") do
        return true
    end

    return false
end

return M
