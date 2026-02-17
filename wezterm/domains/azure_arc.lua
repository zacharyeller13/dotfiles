local wezterm = require("wezterm") --[[@as Wezterm]]

---@class AzureArcDomain
---@field name string VM Name
---@field resource_group string Resource group name

local M = {}

---@return AzureArcDomain[]
function M.list_domains()
    local file = io.open(os.getenv("HOME") .. "/.config/wezterm/domains.json", "r")
    if file then
        local contents = file:read("*a")
        file:close()
        local tbl = wezterm.serde.json_decode(contents)
        return tbl.domains
    end
    return {}
end

---@param domain AzureArcDomain
function M.make_fixup_func(domain)
    return function(cmd)
        cmd.args = { "az", "ssh", "arc", "--resource-group", domain.resource_group, "--name", domain.name:lower() }
        return cmd
    end
end

return M
