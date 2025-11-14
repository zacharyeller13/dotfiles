require("types.space")

local icons = require("icons")
local colors = require("colors")
local tbl = require("helpers.tables")

-- Define standard aerospace commands for reuse
local AERO_LIST_WORKSPACES =
    "aerospace list-workspaces --all --format '%{workspace}%{monitor-appkit-nsscreen-screens-id}%{workspace-is-visible}%{monitor-id}' --json;"
local AERO_LIST_EMPTY_WORKSPACES =
    "aerospace list-workspaces --empty --monitor all --format '%{workspace}%{monitor-appkit-nsscreen-screens-id}%{workspace-is-visible}%{monitor-id}' --json;"
local AERO_LIST_FOCUSED =
    "aerospace list-workspaces --focused --format '%{workspace}%{monitor-appkit-nsscreen-screens-id}%{workspace-is-visible}%{monitor-id}' --json;"

local space_change = Sketchybar.add("event", "aerospace_workspace_change")
local monitor_change = Sketchybar.add("event", "aerospace_move_monitors")

local active_space = {
    width = "dynamic",
    label = { drawing = true, highlight = true, string = icons.spaces.active },
    icon = { drawing = true, highlight = true },
    background = { drawing = true },
}
local default_space = {
    width = "dynamic",
    label = { drawing = true, highlight = false, string = icons.spaces.default },
    icon = { drawing = true, highlight = false },
    background = { drawing = false },
}
local empty_space = {
    width = 0,
    label = { drawing = false },
    icon = { drawing = false },
    background = { drawing = false },
}

-- We can do this synchronously cause we know we only have 9 spaces really
for i = 1, 9, 1 do
    local name = "space." .. i
    local item = Sketchybar.add("item", name, {
        position = "left",
        label = {
            string = icons.spaces.default,
            font = { size = 14 },
            highlight_color = colors.green,
        },
        icon = {
            string = i .. ":",
            highlight_color = colors.green,
            font = { size = 14 },
        },
        background = {
            border_color = colors.green,
            drawing = false,
            -- A bit hacky but works to make a solid bar at the top-ish
            height = 2,
            y_offset = 13,
        },
        padding_left = 2,
        padding_right = 2,
    })

    -- Initial setup on sketchybar start
    Sketchybar.exec(AERO_LIST_EMPTY_WORKSPACES, function(empty_spaces)
        if tbl.list_contains(empty_spaces, "workspace", tostring(i)) then
            item:set(empty_space)
        end
    end)
    Sketchybar.exec(AERO_LIST_WORKSPACES, function(spaces)
        item:set({ display = spaces[i]["monitor-appkit-nsscreen-screens-id"] })
    end)

    item:subscribe(space_change.name, function(env)
        Sketchybar.exec(AERO_LIST_EMPTY_WORKSPACES, function(empty_spaces)
            if env.FOCUSED_WORKSPACE == tostring(i) then
                item:set(active_space)
            elseif tbl.list_contains(empty_spaces, "workspace", tostring(i)) then
                item:set(empty_space)
            else
                item:set(default_space)
            end
        end)
    end)

    item:subscribe(monitor_change.name, function(env)
        Sketchybar.exec(AERO_LIST_FOCUSED, function(spaces)
            if spaces[1].workspace == tostring(i) then
                item:set({ display = spaces[1]["monitor-appkit-nsscreen-screens-id"] })
            end
        end)
    end)

    item:subscribe("mouse.clicked", function()
        Sketchybar.exec("aerospace workspace " .. i)
    end)

    -- Typically if we switch power, we may be going from
    -- a dock to just the built-in screen, so let's check and re-render the
    -- spaces
    item:subscribe("power_source_change", function()
        item:set({ display = "active" })
        Sketchybar.exec(AERO_LIST_WORKSPACES, function(spaces)
            item:set({ display = spaces[i]["monitor-appkit-nsscreen-screens-id"] })
        end)
    end)

    -- If we disconnected while asleep, need to re-render spaces on the correct
    -- monitor again
    item:subscribe("system_woke", function()
        item:set({ display = "active" })
        Sketchybar.exec(AERO_LIST_WORKSPACES, function(spaces)
            item:set({ display = spaces[i]["monitor-appkit-nsscreen-screens-id"] })
        end)
    end)
end
