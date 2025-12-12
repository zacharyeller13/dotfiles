local audio = require("audio")
local encoding = require("encoding")
local vimish = require("vimish")

hs.loadSpoon("EmmyLua")
hs.ipc.cliInstall()

-- Due to symlinks, there may not be a currentDir set at startup; we want to run
-- everything as if from the config dir
if not hs.fs.chdir(hs.configdir) then
    error("Error changing dir to " .. hs.configdir)
end
assert(
    hs.fs.currentDir() == hs.fs.pathToAbsolute(hs.configdir),
    string.format("cwd %s must be the same as the configdir %s", hs.fs.currentDir(), hs.fs.pathToAbsolute(hs.configdir))
)

hs.hotkey.bind({ "cmd", "alt" }, "r", function()
    hs.reload()
end)

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "s", function()
    -- A little faster than hs.execute since we don't need to do a lot
    -- with the output
    local ok, err, code = hs.execute("sketchybar --reload", true)
    if not ok then
        print(err, code)
    end
end)

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "c", function()
    hs.toggleConsole()
end)

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "a", function()
    audio.show_chooser()
end)

hs.hotkey.bind({ "cmd" }, "k", function()
    local clipboard = hs.pasteboard.getContents()
    encoding.copy_event_listener:start()
    hs.eventtap.keyStroke({ "cmd" }, "c")
    hs.timer.doAfter(0.2, function()
        hs.pasteboard.setContents(clipboard)
        encoding.copy_event_listener:stop()
    end)
end)

hs.alert.show("Config loaded")
