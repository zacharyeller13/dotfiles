local colors = require("colors")
local icons = require("icons")

local volume_slider = Sketchybar.add("slider", "volume_slider", 100, {
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
            color = colors.volume_slider_bg,
        },
        knob = {
            string = "􀀁",
            drawing = true,
        },
    },
})

return volume_slider
