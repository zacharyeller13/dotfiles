local wezterm = require("wezterm") --[[@as Wezterm]]
local module = {}
local act = wezterm.action

--- Sets key by adding it to config.keys
---@param keys Key[]
---@param key string
---@param mods string?
---@param action KeyAssignment
function module:set(keys, key, mods, action)
    table.insert(keys, { key = key, mods = mods, action = action })
end

---Updates keybindings
---@param config Config
function module:bind_keys(config)
    ---@param key string
    ---@param mod string?
    ---@param action KeyAssignment
    local set = function(key, mod, action)
        self:set(config.keys, key, mod, action)
    end
    config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

    set("|", "LEADER|SHIFT", act.SplitHorizontal({ domain = "CurrentPaneDomain" }))
    set("_", "LEADER|SHIFT", act.SplitVertical({ domain = "CurrentPaneDomain" }))
    set("h", "LEADER", act.ActivatePaneDirection("Left"))
    set("j", "LEADER", act.ActivatePaneDirection("Down"))
    set("k", "LEADER", act.ActivatePaneDirection("Up"))
    set("l", "LEADER", act.ActivatePaneDirection("Right"))
    set("c", "LEADER", act.SpawnTab("CurrentPaneDomain"))
    set("n", "LEADER", act.ActivateTabRelative(1))
    set("p", "LEADER", act.ActivateTabRelative(-1))
    set(
        ",",
        "SUPER",
        act.SpawnCommandInNewTab({
            cwd = wezterm.home_dir,
            args = { "nvim", wezterm.home_dir .. "/.config/wezterm/wezterm.lua" },
        })
    )
    set("V", "CTRL", act.PasteFrom("Clipboard"))
    set(
        "E",
        "CTRL|SHIFT",
        act.PromptInputLine({
            description = "Enter new tab name",
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        })
    )
end

return module
