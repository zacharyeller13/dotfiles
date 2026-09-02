local colors = require("colors")

-- Equivalent to the --bar domain
Sketchybar.bar({
    height = 30,
    border_color = colors.bar.border,
    shadow = true,
    sticky = true,
    padding_right = 10,
    padding_left = 10,
    blur_radius = 0,
    topmost = "window",
})
