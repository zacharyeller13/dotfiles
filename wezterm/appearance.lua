local wezterm = require("wezterm") --[[@as Wezterm]]
local M = {}

function M.is_dark()
    if wezterm.gui then
        return wezterm.gui.get_appearance():find("Dark")
    end
    return true
end

---Apply to wezterm config
---@param config Config
function M:apply(config)
    if self.is_dark() then
        config.color_scheme = "Tokyo Night"
    else
        config.color_scheme = "Tokyo Night Day"
    end
end

return M
