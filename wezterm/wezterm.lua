local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- appearance.lua
local appearance = require("appearance")
if appearance.is_dark() then
	config.color_scheme = "Tokyo Night"
else
	config.color_scheme = "Tokyo Night Day"
end

-- Window styling
config.window_background_opacity = 0.9

-- Remove the title bar?
config.window_decorations = "RESIZE|INTEGRATED_BUTTONS"
-- Sets font for window frame
config.window_frame = {
	font = wezterm.font({ family = "Jetbrains Mono", weight = "Bold" }),
	font_size = 11,
}

-- Create a status bar at the top
require("status_bar")

-- Keybindings
local keybindings = require("keybindings")
keybindings.bind_keys(config)

-- For pywal
wezterm.add_to_config_reload_watch_list(os.getenv("HOME") .. "/.cache/wal/sequences")

return config
