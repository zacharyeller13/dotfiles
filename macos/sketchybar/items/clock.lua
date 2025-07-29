local clock = Sketchybar.add("item", "clock", {
    position = "right",
    update_freq = 10,
    icon = { string = "  " },
})

-- Add calendar
local calendar = require("items.calendar")
calendar:setup()

---What the clock currently shows, default should be 'time'
---@type "date"
---| "time"
local shown = "time"

---Update clock current date and time
local function update()
    local date = os.date("%Y-%m-%d")
    local time = os.date("%H:%M")
    if shown == "date" then
        clock:set({ label = date })
    else
        clock:set({ label = time })
    end
    calendar:update()
end

local function on_click()
    local date = os.date("%Y-%m-%d")
    local time = os.date("%H:%M")
    if shown == "date" then
        shown = "time"
        clock:set({ label = time })
    else
        shown = "date"
        clock:set({ label = date })
    end
end

local function show_calendar()
    clock:set({
        popup = { drawing = true, align = "right" },
    })
end

local function hide_calendar()
    clock:set({
        popup = { drawing = false },
    })
end

clock:subscribe("routine", update)
clock:subscribe("forced", update)
clock:subscribe("mouse.clicked", on_click)
clock:subscribe("mouse.entered", show_calendar)
clock:subscribe("mouse.exited", hide_calendar)
