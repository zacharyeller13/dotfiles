local modes = require("vimish.modes")

local function get_target_app()
    return hs.application.get("Outlook")
end
---@type hs.application?
local target_app = get_target_app()

local app_watcher = hs.application.watcher.new(function(app_name, event_type, app)
    if event_type == hs.application.watcher.activated then
        -- Basically I guess if this is already running, the app can be cached
        target_app = target_app or get_target_app()
        if target_app and app == target_app then
            modes:activate()
        end
    elseif event_type == hs.application.watcher.deactivated then
        target_app = target_app or get_target_app()
        if target_app and app == target_app then
            modes:deactivate()
        end
    elseif event_type == hs.application.watcher.terminated then
        target_app = target_app or get_target_app()
        if target_app and app == target_app then
            target_app = nil
            modes:terminate()
        end
    elseif event_type == hs.application.watcher.launched then
        -- Need to wait a couple seconds for app to fully launch and get placed
        -- on the proper screen etc.
        hs.timer.doAfter(2, function()
            target_app = target_app or get_target_app()
            if target_app and app == target_app then
                modes:create_status(app)
            end
        end)
    end
end)

return app_watcher
