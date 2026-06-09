require("types.space")
local icons = require("icons")
local colors = require("colors")
local tbl = require("helpers.tables")

---@type table<string, SbarItem?>
local workspaces = {}

local space_change = Sketchybar.add("event", "rift_workspace_changed")
local monitor_change = Sketchybar.add("event", "rift_move_monitors")

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

local function update_spaces()
    ---@param result RiftSpace[]
    Sketchybar.exec("rift-cli query workspaces", function(result)
        for _, rspace in ipairs(result) do
            local space = workspaces[rspace.name]
            if rspace.is_active and space then
                space:set(active_space)
            elseif rspace.window_count == 0 and space then
                space:set(empty_space)
            elseif space then
                space:set(default_space)
            end
        end
    end)
end

---@param item SbarItem
---@param display boolean
local function animate_border(item, display)
    local active = item:query().icon.highlight == "on"
    if not display and active then
        return
    end
    item:set({ background = { border_color = colors.green, drawing = display } })
end

--We can do this synchronously cause we know we only have 9 spaces really
for i = 1, 9, 1 do
    local name = "space." .. i
    local space = Sketchybar.add("item", name, {
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
    workspaces[space.name] = space

    space:subscribe("mouse.clicked", function()
        Sketchybar.exec("rift-cli execute workspace switch " .. i)
    end)
    space:subscribe("mouse.entered", function()
        animate_border(space, true)
    end)
    space:subscribe("mouse.exited", function()
        animate_border(space, false)
    end)
end

-- This requires compiling rift.lua with the same lua version as SbarLua (currently 5.5)
local client, err = require("rift").connect()
if not client then
    error(err)
end
---@param env { INFO: string, EVENT: string, DATA: WorkspaceChangedEvent }
client:subscribe({ "workspace_changed" }, function(env)
    update_spaces()
end)
update_spaces()
