local M = {}

---Close all visible notifications in Notification Center.
function M.close_all()
    hs.task
        .new("/usr/bin/osascript", nil, {
            "-l",
            "JavaScript",
            os.getenv("HOME") .. "/.hammerspoon/jxa/close_notifications.js",
        })
        :start()
end

return M
