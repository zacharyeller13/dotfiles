local wezterm = require("wezterm") --[[@as Wezterm]]

local parallels = require("domains.parallels")
local azure_arc = require("domains.azure_arc")

local M = {}

---Apply customized domains to config
---@param config Config
function M.apply(config)
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
    -- Only run on MacOS where I have parallels
    if wezterm.target_triple == "aarch64-apple-darwin" then
        for _, domain in ipairs(parallels.parallels_list()) do
            table.insert(
                exec_domains,
                wezterm.exec_domain(
                    "parallels:" .. domain.name,
                    parallels.make_fixup_func(domain.name),
                    parallels.make_label_func(domain.name)
                )
            )
        end

        for _, domain in ipairs(azure_arc.list_domains()) do
            table.insert(
                exec_domains,
                wezterm.exec_domain("AzureArc:" .. domain.name, azure_arc.make_fixup_func(domain))
            )
        end
    end

    config.exec_domains = exec_domains
end

return M
