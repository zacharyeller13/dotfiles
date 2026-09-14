local colors = require("colors")
local icons = require("icons")
local power = require("helpers.power")

local battery = Sketchybar.add("item", "battery", {
    position = "right",
    icon = { string = icons.battery._100, color = colors.green },
    label = { string = "100%", color = colors.green },
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

        battery:set({ label = { string = percentage .. "%" } })

        for _ in result:gmatch("AC Power") do
            charging = true
        end
        if charging then
            battery:set({
                icon = { string = icons.battery.charging, color = colors.white },
                label = { color = colors.white },
            })
        else
            if tonumber(percentage) >= 90 then
                battery:set({
                    icon = { string = icons.battery._100, color = colors.green },
                    label = { color = colors.green },
                })
            elseif tonumber(percentage) >= 60 then
                battery:set({
                    icon = { string = icons.battery._75, color = colors.green },
                    label = { color = colors.green },
                })
            elseif tonumber(percentage) >= 40 then
                battery:set({
                    icon = { string = icons.battery._50, color = colors.yellow },
                    label = { color = colors.yellow },
                })
            elseif tonumber(percentage) >= 15 then
                battery:set({
                    icon = { string = icons.battery._20, color = colors.orange },
                    label = { color = colors.orange },
                })
            else
                battery:set({
                    icon = { string = icons.battery._0, color = colors.red },
                    label = { color = colors.red },
                })
            end
        end
    end)
end

battery:subscribe("routine", update)
battery:subscribe("forced", update)
battery:subscribe("system_woke", update)
battery:subscribe("power_source_change", update)

return { battery }
