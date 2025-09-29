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

-- Due to symlinks, there may not be a currentDir set at startup; we want to run
-- everything as if from the config dir
if not hs.fs.chdir(hs.configdir) then
    error("Error changing dir to " .. hs.configdir)
end
assert(
    hs.fs.currentDir() == hs.fs.pathToAbsolute(hs.configdir),
    string.format("cwd %s must be the same as the configdir %s", hs.fs.currentDir(), hs.fs.pathToAbsolute(hs.configdir))
)

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

---Show audio switching chooser
function show_chooser()
    local audio_image = hs.image.imageFromPath("icons/speaker.png")

    local chooser = hs.chooser.new(function(choice)
        print("Choice: " .. hs.inspect(choice))
        if choice then
            change_output(choice.text)
            print(hs.audiodevice.current().name)
        end
    end)
    chooser:choices(function()
        local devices = hs.audiodevice.allOutputDevices()
        local choices = {}
        for _, device in ipairs(devices) do
            table.insert(choices, { image = audio_image, text = device:name(), subText = device:uid() })
        end
        return choices
    end)
    chooser:show()
end

hs.alert.show("Config loaded")
