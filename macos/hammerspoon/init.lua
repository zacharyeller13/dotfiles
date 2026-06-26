local audio = require("audio")
local encoding = require("encoding")
local riftapi = require("riftapi")
require("vimish")

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

hs.hotkey.bind({ "cmd" }, "h", function()
    hs.alert("Oops, no hide")
end)

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "s", function()
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

hs.hotkey.bind({ "alt" }, "c", function()
    local app = hs.application.frontmostApplication()
    local allWins = app:allWindows()
    if #allWins == 1 then
        app:kill()
        hs.alert("Closed app: " .. app:title())
        return
    end
    local win = app:focusedWindow()
    hs.alert("Closed window: " .. win:title())
    win:close()
end)

hs.caffeinate.set("displayIdle", true, true)
hs.caffeinate.set("systemIdle", true, true)
hs.alert.show("Config loaded")
