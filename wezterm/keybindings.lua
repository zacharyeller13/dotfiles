local wezterm = require("wezterm") --[[@as Wezterm]]
local module = {}
local act = wezterm.action

---Updates keybindings
---@param config Config
function module.bind_keys(config)
    config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

    config.keys = {
        {
            key = "|",
            mods = "LEADER|SHIFT",
            action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
        },
        {
            key = "_",
            mods = "LEADER|SHIFT",
            action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
        },
        {
            key = "h",
            mods = "LEADER",
            action = act.ActivatePaneDirection("Left"),
        },
        {
            key = "j",
            mods = "LEADER",
            action = act.ActivatePaneDirection("Down"),
        },
        {
            key = "k",
            mods = "LEADER",
            action = act.ActivatePaneDirection("Up"),
        },
        {
            key = "l",
            mods = "LEADER",
            action = act.ActivatePaneDirection("Right"),
        },
        {
            key = "c",
            mods = "LEADER",
            action = act.SpawnTab("CurrentPaneDomain"),
        },
        {
            key = "n",
            mods = "LEADER",
            action = act.ActivateTabRelative(1),
        },
        {
            key = "p",
            mods = "LEADER",
            action = act.ActivateTabRelative(-1),
        },
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
