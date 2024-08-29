local wezterm = require("wezterm")
local module = {}

function module.bind_keys(config)
	config.keys = {
		{
			key = ",",
			mods = "SUPER",
			action = wezterm.action.SpawnCommandInNewTab({
				cwd = wezterm.home_dir,
				args = { "nvim", wezterm.home_dir .. "/.config/wezterm/wezterm.lua" },
			}),
		},
	}
end

return module
