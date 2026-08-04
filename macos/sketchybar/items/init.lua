local colors = require("colors")

-- require("items.aerospace")
local rift_spaces = require("items.rift_spaces")
require("items.front_app")

local spaces = Sketchybar.add("bracket", "left", { "/space\\..*/" }, { background = { color = colors.black } })
spaces:subscribe("front_app_switched", function()
    rift_spaces.update_spaces()
end)

local clock = table.unpack(require("items.clock"), 1)
local volume_icon, volume_slider = table.unpack(require("items.volume"), 1)
local battery = table.unpack(require("items.battery"), 1)

Sketchybar.add(
    "bracket",
    "right",
    { clock.name, battery.name, volume_icon.name, volume_slider.name },
    { background = { color = colors.black } }
)
require("items.network")
