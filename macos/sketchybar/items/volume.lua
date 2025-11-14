local colors = require("colors")
local icons = require("icons")

local volume_slider = Sketchybar.add("slider", 100, {
    position = "right",
    updates = true,
    label = { drawing = false },
    icon = { drawing = false },
    slider = {
        highlight_color = colors.blue,
        width = 0,
        background = {
            height = 6,
            corner_radius = 3,
            color = colors.bg2,
        },
        knob = {
            string = "􀀁",
            drawing = true,
        },
    },
})

local volume_icon = Sketchybar.add("item", {
    position = "right",
    icon = {
        string = icons.volume._100,
        align = "left",
        font = {
            style = "Regular",
            size = 18.0,
        },
    },
    label = {
        align = "left",
        font = {
            style = "Regular",
        },
    },
})

volume_slider:subscribe("mouse.clicked", function(env)
    Sketchybar.exec("aerospace volume set " .. env.PERCENTAGE)
end)

volume_slider:subscribe("volume_change", function(env)
    local volume = tonumber(env.INFO)
    local icon = icons.volume._0
    if volume > 60 then
        icon = icons.volume._100
    elseif volume > 30 then
        icon = icons.volume._66
    elseif volume > 10 then
        icon = icons.volume._33
    elseif volume > 0 then
        icon = icons.volume._10
    end

    volume_icon:set({ label = volume .. "%", icon = { string = icon } })
    volume_slider:set({ slider = { percentage = volume } })
end)

local function animate_slider_width(width)
    Sketchybar.animate("tanh", 30.0, function()
        volume_slider:set({ slider = { width = width } })
    end)
end

volume_icon:subscribe("mouse.clicked", function()
    if tonumber(volume_slider:query().slider.width) > 0 then
        animate_slider_width(0)
    else
        animate_slider_width(100)
    end
end)
