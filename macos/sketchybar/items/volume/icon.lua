local colors = require("colors")
local icons = require("icons")

local volume_icon = Sketchybar.add("item", "volume_icon", {
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

return volume_icon
