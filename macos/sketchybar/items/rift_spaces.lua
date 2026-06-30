require("types.space")
local icons = require("icons")
local colors = require("colors")
local riftapi = require("riftapi")

---@type table<string, SbarItem?>
local workspaces = {}

local active_space = {
    width = "dynamic",
    label = { drawing = true, highlight = true, string = icons.spaces.active },
    icon = { drawing = true, highlight = true },
    background = { drawing = true },
}
local default_space = {
    width = "dynamic",
    label = { drawing = true, highlight = false, string = icons.spaces.default, color = colors.space.inactive },
    icon = { drawing = true, highlight = false, color = colors.space.inactive },
    background = { drawing = false },
}
local empty_space = {
    width = 0,
    label = { drawing = false },
    icon = { drawing = false },
    background = { drawing = false },
}

local function update_spaces()
    local result, err = riftapi.query.workspaces()
    if not result or err ~= nil then
        print(err)
        return
    end
    for _, rspace in ipairs(result) do
        local space = workspaces[rspace.name]
        if rspace.is_active and space then
            space:set(active_space)
        elseif #rspace.windows == 0 and space then
            space:set(empty_space)
        elseif space then
            space:set(default_space)
        end
    end
end

---@param item SbarItem
---@param display boolean
local function animate_border(item, display)
    local active = item:query().icon.highlight == "on"
    if not display and active then
        return
    end
    item:set({ background = { border_color = colors.space.active, drawing = display } })
end

--We can do this synchronously cause we know we only have 9 spaces really
for i = 1, 9, 1 do
    local name = "space." .. i
    local space = Sketchybar.add("item", name, {
        position = "left",
        label = {
            string = icons.spaces.default,
            font = { size = 14 },
            highlight_color = colors.space.active,
        },
        icon = {
            string = i .. ":",
            highlight_color = colors.space.active,
            font = { size = 14 },
        },
        background = {
            border_color = colors.space.active,
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
        local rift = riftapi
        rift.workspace.switch(i)
    end)
    space:subscribe("mouse.entered", function()
        animate_border(space, true)
    end)
    space:subscribe("mouse.exited", function()
        animate_border(space, false)
    end)
end

riftapi.subscribe({ "workspace_changed" }, function(env)
    update_spaces()
end)
update_spaces()
