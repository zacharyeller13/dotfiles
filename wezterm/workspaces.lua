local wezterm = require("wezterm") --[[@as Wezterm]]
local mux = wezterm.mux
local act = wezterm.action

local HOME = wezterm.home_dir

---@class Workspace
---@field search_dirs string[]
local M = {
    search_dirs = { HOME .. "/dev", HOME .. "/work/dev" },
}

wezterm.on("gui-startup", function(cmd)
    local file = io.open(HOME .. "/.config/wezterm/workspaces.json", "r")
    if file then
        local contents = file:read("*a")
        file:close()
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

---Split directory into separate strings
---@param path string
---@return string[]
local function split_path(path)
    local parts = {}
    for part in path:gmatch("[^/]+") do
        table.insert(parts, part)
    end
    return parts
end

--- Lists projects from ~/**/dev directories for use with InputSelector
---@return {label: string, id: string}[]
function M:list_projects()
    local projects = {}

    local ok, stdout, stderr =
        wezterm.run_child_process({ "fd", "-H", "-t", "d", "^\\.git$", table.unpack(self.search_dirs) })
    if not ok then
        wezterm.log_error("Error getting projects: ", stderr)
        return {}
    end

    for line in stdout:gmatch("[^\r\n]+") do
        local path = line:gsub("/.git/$", "")
        local label = split_path(path:gsub(HOME, ""))
        local project = { label = label[#label], id = path }
        table.insert(projects, project)
    end

    return projects
end

---Action callback from InputSelector to spawn the selected project
---@param window Window
---@param pane Pane
---@param id string
---@param label string
function M.spawn_project(window, pane, id, label)
    if not label and not id then
        wezterm.log_info("cancelled")
        return
    end
    window:perform_action(
        act.SwitchToWorkspace({
            name = label,
            spawn = {
                domain = "DefaultDomain",
                label = label,
                cwd = id,
            },
        }),
        pane
    )
end

return M
