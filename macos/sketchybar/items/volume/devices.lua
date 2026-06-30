local icons = require("icons")

---@class AudioDevices
local M = {}

---@class HSAudioDevice
---@field name string
---@field muted boolean

local hs_cmd = [['local output = hs.audiodevice.current()
local input = hs.audiodevice.current(true)
local out = hs.json.encode({
    output = { name = output.name, muted = output.muted },
    input = {name = input.name, muted = input.muted }
})
print(out)'
]]

---Get the current input and output audio devices
---and perform some callback on the result
---@param callback fun(result: {output: HSAudioDevice, input: HSAudioDevice}, exit_code: integer)
local function update(callback)
    Sketchybar.exec("hs -c " .. hs_cmd, callback)
end

---Setup input/output devices as popups on the parent item
---@param parent_item SbarItem
function M.setup(parent_item)
    local audio_output = Sketchybar.add("item", "volume.devices.output", {
        position = "popup." .. parent_item.name,
        width = "dynamic",
        label = { font = { size = 10 }, align = "right" },
        icon = { string = icons.audio.output },
    })
    local audio_input = Sketchybar.add("item", "volume.devices.input", {
        position = "popup." .. parent_item.name,
        width = "dynamic",
        label = { font = { size = 10 }, align = "right" },
        icon = { string = icons.audio.input },
    })
    parent_item:subscribe("mouse.entered", function()
        update(function(audio)
            local output_icon = icons.audio.output
            if audio.output.muted then
                output_icon = icons.audio.output_muted
            end
            local input_icon = icons.audio.input
            if audio.input.muted then
                input_icon = icons.audio.input_muted
            end

            audio_output:set({ label = audio.output.name, icon = output_icon })
            audio_input:set({ label = audio.input.name, icon = input_icon })
            parent_item:set({ popup = { drawing = true, align = "center" } })
        end)
    end)
    parent_item:subscribe("mouse.exited", function()
        parent_item:set({ popup = { drawing = false } })
    end)
end

M.current = update

return M
