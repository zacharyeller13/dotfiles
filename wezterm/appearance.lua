local wezterm = require("wezterm") --[[@as Wezterm]]
local module = {}

function module.is_dark()
    if wezterm.gui then
        return wezterm.gui.get_appearance():find("Dark")
    end
    return true
end

return module
