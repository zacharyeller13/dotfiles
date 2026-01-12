local wezterm = require("wezterm") --[[@as Wezterm]]
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
    local file = io.open(os.getenv("HOME") .. "/.config/wezterm/workspaces.json", "r")
    if file then
        local contents = file:read("*a")
        local tbl = wezterm.serde.json_decode(contents)
        for _, workspace in ipairs(tbl) do
            local tab, pane, window = mux.spawn_window({
                workspace = workspace.workspace,
                domain = workspace.domain,
            })
            -- Workaround for cwd not actually working especially in Parallels
            pane:send_text("cd '" .. workspace.cwd .. "'\n")

            local split_pane = pane:split({
                direction = workspace.split.direction,
                domain = workspace.split.domain,
                args = { "cd", workspace.split.cwd },
            })
            -- Workaround for cwd not actually working especially in Parallels
            split_pane:send_text("cd '" .. workspace.split.cwd .. "'\n")
        end
    end

    -- Default workspace, no setup
    mux.spawn_window({
        workspace = "default",
        domain = "DefaultDomain",
    })
    mux.set_active_workspace("default")
end)
