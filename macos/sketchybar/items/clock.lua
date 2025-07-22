local clock = Sketchybar.add("item", "clock", {
    position = "right",
    update_freq = 10,
    icon = { string = "  " },
})

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

---@param cal string
Sketchybar.exec("cal", function(cal)
    local calendar_rows = {}
    for match in cal:gmatch("[^\r\n]+") do
        local trimmed, _ = match:gsub("%s+", "")
        if trimmed ~= "" then
            table.insert(calendar_rows, match)
        end
    end

    for i, cal_row in ipairs(calendar_rows) do
        Sketchybar.add("item", "calendar." .. i, {
            -- How do we get this width? Trial and error and guessing
            -- If we leave it as 'dynamic', some of the characters get truncated
            width = 160,
            position = "popup.clock",
            icon = { drawing = false },
            label = { string = cal_row },
        })
    end
end)

local function show_calendar(env)
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
