local colors = require("colors")

-- Equivalent to the --bar domain
Sketchybar.bar({
    height = 30,
    -- color = colors.bar.bg,
    border_color = colors.bar.border,
    shadow = false,
    sticky = true,
    padding_right = 10,
    padding_left = 10,
    blur_radius = 0,
    topmost = "window",
})
