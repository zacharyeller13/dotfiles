local wezterm = require("wezterm")
local module = {}
local act = wezterm.action

---Updates keys
---@param config table
function module.bind_keys(config)
	config.keys = {
		{
			key = ",",
			mods = "SUPER",
			action = act.SpawnCommandInNewTab({
				cwd = wezterm.home_dir,
				args = { "nvim", wezterm.home_dir .. "/.config/wezterm/wezterm.lua" },
			}),
		},
		{
			key = "V",
			mods = "CTRL",
			action = act.PasteFrom("Clipboard"),
		},
	}
end

return module
