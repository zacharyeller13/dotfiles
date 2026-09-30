local wezterm = require("wezterm") --[[@as Wezterm]]

local config = wezterm.config_builder() --[[@as Config]]

if wezterm.target_triple == "aarch64-apple-darwin" then
    config.default_prog = { "/bin/zsh" }
else
    config.default_prog = { "/usr/bin/zsh" }
end
config.quick_select_patterns = {
    "[0-9]{5,7}\\.[0-9]{5}", -- matter numbers
}

require("options").apply(config)
require("domains").apply(config)
require("appearance"):apply(config)
require("keybindings"):bind_keys(config)

-- Config isn't updated in these modules
require("status_bar")
require("workspaces")

return config
