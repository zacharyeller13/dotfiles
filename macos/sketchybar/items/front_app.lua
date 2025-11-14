Sketchybar.add("item", "chevron", {
    position = "left",
    icon = { string = " " },
    label = { drawing = false },
})

local front_app = Sketchybar.add("item", "front_app", {
    position = "left",
    icon = { drawing = false },
})

front_app:subscribe("front_app_switched", function(env)
    front_app:set({ label = { string = env.INFO } })
end)
