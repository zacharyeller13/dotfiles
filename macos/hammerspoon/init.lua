hs.loadSpoon("EmmyLua")
hs.ipc.cliInstall()

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "w", function()
    hs.alert.show("hello world")
    hs.notify.new({ title = "Hammerspoon", informativeText = "Hello World" }):send()
end)

hs.hotkey.bind({ "cmd", "alt" }, "r", function()
    hs.reload()
end)

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "s", function()
    hs.execute("sketchybar --reload", true)
end)

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "c", function()
    hs.toggleConsole()
end)

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "a", function()
    show_chooser()
end)

function test()
    print(hs.inspect(hs.audiodevice.current()))
    for _, device in ipairs(hs.audiodevice.allDevices()) do
        print(device:name(), device:inUse())
    end
end

---@param to string Audio device name to switch to
function change_output(to)
    local current_device = hs.audiodevice.current()
    if current_device.name == to then
        return
    end
    local next_device = hs.audiodevice.findOutputByName(to)
    if next_device then
        next_device:setDefaultOutputDevice()
    end
end

function show_chooser()
    local chooser = hs.chooser.new(function(choice)
        print("Choice: " .. hs.inspect(choice))
        change_output(choice.text)
        print(hs.audiodevice.current().name)
    end)
    chooser:choices(function()
        local devices = hs.audiodevice.allDevices()
        local choices = {}
        for _, device in ipairs(devices) do
            table.insert(choices, { text = device:name(), subText = device:uid() })
        end
        return choices
    end)
    chooser:show()
end

hs.alert.show("Config loaded")
