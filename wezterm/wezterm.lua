local wezterm = require("wezterm") --[[@as Wezterm]]

local config = wezterm.config_builder() --[[@as Config]]

require("options").apply(config)
require("domains").apply(config)
require("appearance"):apply(config)
require("keybindings"):bind_keys(config)

-- Config isn't updated in these modules
require("status_bar")
require("workspaces")

return config
