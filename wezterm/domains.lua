local wezterm = require("wezterm") --[[@as Wezterm]]

---@class ParallelsList
---@field uuid string UUID of a VM
---@field status 'running'|'suspended'|'stopped' VM Status
---@field ip_configured string
---@field name string VM Name. Can be used as arg when starting/listing VMs

local M = {}

---Return list of parallels VMs. Right now just Ubuntu since it's the only
---VM with SSH enabled
---@return ParallelsList[] #Empty if there is an error, otherwise list of parallels vms
local function parallels_list()
    local success, stdout, stderr = wezterm.run_child_process({
        "/usr/local/bin/prlctl",
        "list",
        "Ubuntu",
        "--json",
    })

    if not success then
        wezterm.log_error("Error listing parallels: ", stderr)
        return {}
    end

    return wezterm.json_parse(stdout)
end

---@param name string Parallels VM name
local function make_parallels_fixup_func(name)
    return function(cmd)
        local success, stdout, stderr = wezterm.run_child_process({
            "/usr/local/bin/prlctl",
            "list",
            name,
            "--json",
        })

        if not success then
            wezterm.log_error("Error listing parallels: ", stderr)
        end

        local domain = wezterm.json_parse(stdout)[1]
        if domain.status ~= "running" then
            local success, stdout, stderr = wezterm.run_child_process({ "/usr/local/bin/prlctl", "start", name })
            if not success then
                wezterm.log_error("Error starting VM: ", name, stderr)
            end
        end

        cmd.args = { "ssh", name:lower() }
        return cmd
    end
end

---@param name string Parallels VM name
local function make_parallels_label_func(name)
    return function()
        local success, stdout, stderr = wezterm.run_child_process({
            "/usr/local/bin/prlctl",
            "list",
            name,
            "--json",
        })

        if not success then
            wezterm.log_error("Error listing parallels: ", stderr)
        end

        local domain = wezterm.json_parse(stdout)[1]
        return domain.status
    end
end

---Apply customized domains to config
---@param config Config
function M.apply_domains(config)
    -- Need to be able to start straight in to WSL if we're on Windows
    -- And also be able to select powershell
    if #wezterm.default_wsl_domains() > 0 then
        config.default_domain = wezterm.default_wsl_domains()[1].name
        config.launch_menu = {
            {
                label = "Powershell",
                domain = { DomainName = "local" },
                args = { "C:/Program Files/Powershell/7/pwsh.exe" },
            },
        }
        return
    end

    local exec_domains = {}
    for _, domain in ipairs(parallels_list()) do
        table.insert(
            exec_domains,
            wezterm.exec_domain(
                "parallels:" .. domain.name,
                make_parallels_fixup_func(domain.name),
                make_parallels_label_func(domain.name)
            )
        )
    end

    config.exec_domains = exec_domains
end

return M
