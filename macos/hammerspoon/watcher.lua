---Watch a specific application and log any new windows
---@param name string
---@return hs.axuielement.observer?
local function watchApp(name)
    local app = hs.application.find(name)
    if not app then
        print("not running: " .. name)
        return
    end
    local appEl = hs.axuielement.applicationElement(app)

    local obs = hs.axuielement.observer.new(app:pid())
    obs:callback(function(obsEl, element, notification, details)
        if notification == "AXWindowCreated" then
            -- window is brand new; role/subrole sometimes need a beat to populate
            hs.timer.doAfter(0.05, function()
                local role = element:attributeValue("AXRole")
                local subrole = element:attributeValue("AXSubrole")
                local title = element:attributeValue("AXTitle")
                print(
                    string.format(
                        "NEW [%s]  role=%s  subrole=%s  title=%s",
                        notification,
                        tostring(role),
                        tostring(subrole),
                        tostring(title)
                    )
                )
            end)
        end
    end)
    obs:addWatcher(appEl, "AXWindowCreated")
    print("watching " .. name .. " (pid " .. app:pid() .. ")")
    return obs -- keep a reference! if it's garbage collected the observer stops
end

return watchApp
