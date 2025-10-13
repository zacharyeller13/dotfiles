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
    config.keys = config.keys or {}

    ---@param key string
    ---@param mod string?
    ---@param action KeyAssignment
    local set = function(key, mod, action)
        self:set(config.keys, key, mod, action)
    end
    config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

    -- Passthrough <C-a> to Neovim on 2nd press to not lose increment integer functinality
    set("a", "LEADER|CTRL", act.SendKey({ key = "a", mods = "CTRL" }))

    -- Splits/Panes
    set("|", "LEADER|SHIFT", act.SplitHorizontal({ domain = "CurrentPaneDomain" }))
    set("_", "LEADER|SHIFT", act.SplitVertical({ domain = "CurrentPaneDomain" }))
    set("h", "LEADER", act.ActivatePaneDirection("Left"))
    set("j", "LEADER", act.ActivatePaneDirection("Down"))
    set("k", "LEADER", act.ActivatePaneDirection("Up"))
    set("l", "LEADER", act.ActivatePaneDirection("Right"))

    -- Tabs
    set("c", "LEADER", act.SpawnTab("CurrentPaneDomain"))
    for i = 1, 8 do
        set(tostring(i), "LEADER", act.ActivateTab(i - 1))
    end
    set("n", "LEADER", act.ActivateTabRelative(1))
    set("p", "LEADER", act.ActivateTabRelative(-1))

    set("V", "CTRL", act.PasteFrom("Clipboard"))

    -- Rename tabs
    set(
        ",",
        "LEADER",
        act.PromptInputLine({
            description = "Enter new tab name",
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        })
    )

    -- Move Tabs
    set(">", "LEADER", act.MoveTabRelative(1))
    set("<", "LEADER", act.MoveTabRelative(-1))

    -- Open select launch menu
    set("o", "LEADER", act.ShowLauncherArgs({ flags = "LAUNCH_MENU_ITEMS|DOMAINS" }))
end

return module
