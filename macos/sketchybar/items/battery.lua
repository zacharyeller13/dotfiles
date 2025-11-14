local icons = require("icons")
local power = require("helpers.power")

local battery = Sketchybar.add("item", "battery", {
    position = "right",
    icon = icons.battery._100,
    label = "100%",
    update_freq = 120,
})

local function update()
    ---@param result string
    Sketchybar.exec("pmset -g batt", function(result)
        local percentage = ""
        local charging = false
        for match in result:gmatch("%d+%%") do
            percentage, _ = match:gsub("%%", "")
        end

        battery:set({ label = percentage .. "%" })

        for _ in result:gmatch("AC Power") do
            charging = true
        end
        if charging then
            battery:set({ icon = icons.battery.charging })
        else
            if tonumber(percentage) >= 90 then
                battery:set({ icon = icons.battery._100 })
            elseif tonumber(percentage) >= 60 then
                battery:set({ icon = icons.battery._75 })
            elseif tonumber(percentage) >= 40 then
                battery:set({ icon = icons.battery._50 })
            elseif tonumber(percentage) >= 15 then
                battery:set({ icon = icons.battery._20 })
            else
                battery:set({ icon = icons.battery._0 })
            end
        end
    end)
end

battery:subscribe("routine", update)
battery:subscribe("forced", update)
battery:subscribe("system_woke", update)
battery:subscribe("power_source_change", update)
