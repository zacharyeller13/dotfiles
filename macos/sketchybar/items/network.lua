---Sleep 5 to allow sketchybar to start, then add any cisco app icons as aliases
---@param aliases table<string>
---@param exit_code integer
Sketchybar.exec("sleep 5 && sketchybar --query default_menu_items", function(aliases, exit_code)
    for i, alias in ipairs(aliases) do
        if alias:lower():match("cisco") then
            Sketchybar.add("alias", alias, { position = "right" })
        end
    end
end)
