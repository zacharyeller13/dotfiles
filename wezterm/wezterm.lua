local wezterm = require("wezterm") --[[@as Wezterm]]
local domains = require("domains")

local config = wezterm.config_builder() --[[@as Config]]

config.tab_bar_at_bottom = true
config.show_tabs_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.use_fancy_tab_bar = false

domains.apply_domains(config)

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
config.window_decorations = "TITLE|RESIZE"
-- Sets font for window frame
-- config.window_frame = {
--     font = wezterm.font({ family = "JetBrains Mono", weight = "Bold" }),
--     font_size = 11,
-- }

-- Global font
if wezterm.target_triple == "aarch64-apple-darwin" then
    config.font = wezterm.font_with_fallback({ "JetBrains Mono", "SF Pro" })
    config.window_decorations = "RESIZE"
else
    config.font = wezterm.font_with_fallback({ "JetBrains Mono", "JetBrainsMono Nerd Font", "Font Awesome 7 Free" })
end

-- Create a status bar at the top
require("status_bar")

-- Keybindings
local keybindings = require("keybindings")
keybindings:bind_keys(config)

-- Workspaces
require("workspaces")

return config
