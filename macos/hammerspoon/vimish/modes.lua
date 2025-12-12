-- Create a new status bar for use with the modes
local status = require("vimish.status")

---@class Modes
---@field insert hs.hotkey.modal
---@field normal hs.hotkey.modal
---@field status Status
---@field mode hs.hotkey.modal The current mode
local M = {}
M.__index = M

---@enum Mode
local MODE = {
    Normal = "Normal",
    Insert = "Insert",
}
local normal = hs.hotkey.modal.new({})
local insert = hs.hotkey.modal.new({})

normal:bind({}, "i", nil, function()
    normal:exit()
    insert:enter()
end)
insert:bind({}, "escape", nil, function()
    insert:exit()
    normal:enter()
end)

function M:activate()
    if not self.status then
        local app = hs.application.frontmostApplication()
        self:create_status(app)
    end
    self.mode:enter()
    self.status:show()
end

function M:deactivate()
    self.mode:exit()
    self.status:hide()
end

function M:terminate()
    self.mode:exit()
    self.status:hide()
    self.status:delete()
    self.status = nil
end

function normal:entered()
    if M.status then
        M.status:set(MODE.Normal)
    end
    M.mode = normal
end

function insert:entered()
    if M.status then
        M.status:set(MODE.Insert)
    end
    M.mode = insert
end

---Create new status indicator tied to the targeted app
---@param app hs.application
function M:create_status(app)
    local frame = app:mainWindow():frame()
    self.status = status.new(frame)
end

---Set a keymap for a specific mode
---@param mode "n"|"i" Normal or insert mode
---@param lhs string | string[] Key source with optional mods
---@param rhs string | string[] | fun(opts: table<string, any>) Key destination with optional mods, or a function to be called
---@param opts? { message: string, app?: string } Additional bind options
local function set(mode, lhs, rhs, opts)
    opts = opts or {}
    local dest_mode

    if mode == "n" then
        dest_mode = normal
    elseif mode == "i" then
        dest_mode = insert
    end

    ---@type string[]
    local lhs_mods = {}
    if type(lhs) == "table" then
        lhs_mods = { table.unpack(lhs, 1, #lhs - 1) }
        lhs = lhs[#lhs]
    end

    ---@type string[]
    local rhs_mods = {}
    if type(rhs) == "table" then
        rhs_mods = { table.unpack(rhs, 1, #rhs - 1) }
        rhs = rhs[#rhs]
    end

    if type(rhs) == "function" then
        dest_mode:bind(lhs_mods, lhs, opts.message, function()
            local target_app = hs.application.get(opts.app)
            -- If this is triggered not in our target app there's a problem
            assert(hs.application.frontmostApplication() == target_app)
            rhs({ app = target_app })
        end)
        return
    end

    dest_mode:bind(lhs_mods, lhs, opts.message, function()
        local target_app = hs.application.get(opts.app)
        -- If this is triggered not in our target app there's a problem
        assert(hs.application.frontmostApplication() == target_app)
        hs.eventtap.keyStroke(rhs_mods, rhs, 10000, target_app)
    end)
end

local target_app = "Outlook"

set("n", "b", { "alt", "left" }, { app = target_app })
set("n", "w", { "alt", "right" }, { app = target_app })
set("n", { "shift", "a" }, function(opts)
    local mods = { "cmd" }
    local keys = "right"
    assert(opts.app)

    hs.eventtap.keyStroke(mods, keys, 10000, opts.app)
    normal:exit()
    insert:enter()
end, { app = target_app })

set("n", "o", function(opts)
    assert(opts.app)

    hs.eventtap.keyStroke({ "cmd" }, "right", 10000, opts.app)
    hs.eventtap.keyStroke({}, "return", 10000, opts.app)
    normal:exit()
    insert:enter()
end, { app = target_app })

set("n", "h", "left", { app = target_app })
set("n", "l", "right", { app = target_app })
set("n", "j", "down", { app = target_app })
set("n", "k", "up", { app = target_app })

M.mode = normal
M.normal = normal
M.insert = insert

return M
