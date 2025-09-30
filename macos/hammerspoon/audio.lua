local M = {}

local audio_icon = hs.image.imageFromPath("icons/speaker.png")
local active_audio_icon = hs.image.imageFromPath("icons/active-speaker.png")

---@param to string Audio device name to switch to
---@param notify? boolean Show a notification that the audio output has changed
local function change_output(to, notify)
    notify = notify or false
    local current_device = hs.audiodevice.current()
    if current_device.name == to then
        return
    end
    local next_device = hs.audiodevice.findOutputByName(to)
    if next_device then
        next_device:setDefaultOutputDevice()
        if notify then
            hs.alert.show("Audio Output set to " .. to)
        end
    end
end

---Select active icon if device is the current output device
---@param device hs.audiodevice Device to select icon
---@return hs.image? #Selected icon
local function select_icon(device)
    local current = hs.audiodevice.current()
    if device:uid() == current.uid then
        return active_audio_icon
    end
    return audio_icon
end

---Show audio switching chooser
local function show_chooser()
    local chooser = hs.chooser.new(function(choice)
        print("Choice: " .. hs.inspect(choice))
        if choice then
            change_output(choice.text, true)
            print(hs.audiodevice.current().name)
        end
    end)
    chooser:choices(function()
        local devices = hs.audiodevice.allOutputDevices()
        local current = hs.audiodevice.current()
        local choices = {}
        for _, device in ipairs(devices) do
            -- device:uid() == current.uid
            table.insert(choices, {
                image = select_icon(device),
                text = device:name(),
                subText = device:uid(),
            })
        end
        return choices
    end)
    chooser:show()
end

M.show_chooser = show_chooser

return M
