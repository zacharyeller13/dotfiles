---@class Calendar
---@field calendar_rows table
local M = {}

M.calendar_rows = {}

function M:update()
    Sketchybar.exec("cal", function(cal)
        local day = os.date("%d") --[[@as string]]
        -- Need to strip a leading 0 to match the calendar output
        day = day:gsub("^0", "")

        local i = 1
        for match in cal:gmatch("[^\r\n]+") do
            local trimmed, _ = match:gsub("%s+", "")
            if trimmed ~= "" then
                match, _ = match:gsub(" " .. day .. " ", "[" .. day .. "]")
                self.calendar_rows[i]:set({ label = { string = match } })
                i = i + 1
            end
        end
    end)
end

function M:setup()
    ---@param cal string
    Sketchybar.exec("cal", function(cal)
        local day = os.date("%d") --[[@as string]]
        day = day:gsub("^0", "")

        local i = 1
        for match in cal:gmatch("[^\r\n]+") do
            local trimmed, _ = match:gsub("%s+", "")
            if trimmed ~= "" then
                match, _ = match:gsub(" " .. day .. " ", "[" .. day .. "]")
                week = Sketchybar.add("item", "calendar." .. i, {
                    -- How do we get this width? Trial and error and guessing
                    -- If we leave it as 'dynamic', some of the characters get truncated
                    width = 160,
                    position = "popup.clock",
                    icon = { drawing = false },
                    label = { string = match },
                    update_freq = 86400, -- 1 day
                })
                i = i + 1

                table.insert(self.calendar_rows, week)
            end
        end
    end)
end

return M
