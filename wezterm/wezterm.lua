local wezterm = require("wezterm") --[[@as Wezterm]]

local config = wezterm.config_builder()

config.tab_bar_at_bottom = true
config.show_tabs_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.use_fancy_tab_bar = false

-- Need to be able to start straight in to WSL if we're on Windows
-- And also be able to select powershell
if #wezterm.default_wsl_domains() > 0 then
    config.default_domain = wezterm.default_wsl_domains()[1].name
    config.launch_menu = {
        {
            label = "Powershell",
            domain = { DomainName = "local" },
            args = { "C:/Program Files/Powershell/7/pwsh.exe" },
        },
    }
end

-- appearance.lua
local appearance = require("appearance")
if appearance.is_dark() then
    config.color_scheme = "Tokyo Night"
else
    config.color_scheme = "Tokyo Night Day"
end

-- Disable bell
config.audible_bell = "Disabled"

-- Window styling
config.window_background_opacity = 0.9

-- Remove title bar
config.window_decorations = "TITLE | RESIZE"
-- Sets font for window frame
config.window_frame = {
    font = wezterm.font({ family = "Jetbrains Mono", weight = "Bold" }),
    font_size = 11,
}

-- Global font
config.font = wezterm.font_with_fallback({ "JetBrains Mono", "JetBrainsMono Nerd Font", "Font Awesome 7 Free" })

-- Create a status bar at the top
require("status_bar")

-- Keybindings
local keybindings = require("keybindings")
keybindings:bind_keys(config)

-- Event for scrollback
require("tinkering")

-- For pywal
-- wezterm.add_to_config_reload_watch_list(os.getenv("HOME") .. "/.cache/wal/sequences")

return config
