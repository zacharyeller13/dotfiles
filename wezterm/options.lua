local wezterm = require("wezterm") --[[@as Wezterm]]

---@class Options
local M = {}

---Apply options to wezterm config
---@param config Config
function M.apply(config)
    config.tab_bar_at_bottom = true
    config.show_tabs_in_tab_bar = true
    config.show_new_tab_button_in_tab_bar = false
    config.use_fancy_tab_bar = false
    config.tab_max_width = 32

    -- Disable bell
    config.audible_bell = "Disabled"

    -- Window styling
    config.window_background_opacity = 0.9

    -- Remove title bar
    config.window_decorations = "TITLE|RESIZE"

    -- Global font
    if wezterm.target_triple == "aarch64-apple-darwin" then
        config.font = wezterm.font_with_fallback({ "JetBrains Mono", "SF Pro" })
        config.window_decorations = "RESIZE"
        config.set_environment_variables = {
            PATH = "/opt/homebrew/bin:/usr/local/bin:" .. os.getenv("PATH"),
        }
    else
        config.font = wezterm.font_with_fallback({ "JetBrains Mono", "JetBrainsMono Nerd Font", "Font Awesome 7 Free" })
    end
end

return M
