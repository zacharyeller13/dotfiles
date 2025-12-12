---@class Status
---@field canvas hs.canvas
local M = {}
M.__index = M

---Create a new status indicator
---in the bottom right corner of the supplied frame (or the main screen)
---with a height and width of 20x200
---@param frame? hs.geometry frame on which to attach status
function M.new(frame)
    local width = 200
    local height = 20

    local screen = hs.screen.mainScreen()
    frame = frame or screen:frame()
    local x = frame.bottomright.x - width
    local y = frame.bottomright.y - height
    local canvas = hs.canvas.new({ x = x, y = y, w = width, h = height })

    canvas:appendElements({
        type = "rectangle",
        action = "fill",
        fillColor = { red = 5, green = 5, blue = 5, alpha = 0.7 },
        roundedRectRadii = { xRadius = 2, yRadius = 2 },
    }, {
        type = "text",
        text = "Normal",
        textColor = { red = 0, green = 0, blue = 0, alpha = 1 },
        textSize = 12,
        textAlignment = "center",
    })

    return setmetatable({ canvas = canvas }, M)
end

---Update mode text
---@param mode Mode
function M:set(mode)
    -- No need to iterate or anything, we know it will be element at index 2
    self.canvas:assignElement({
        type = "text",
        text = mode,
        textColor = { red = 0, green = 0, blue = 0, alpha = 1 },
        textSize = 12,
        textAlignment = "center",
    }, 2)
end

function M:delete()
    self.canvas:delete()
    self.canvas = nil
end

---Wrapper for canvas:show()
function M:show()
    self.canvas:show()
end

---Wrapper for canvas:hide()
function M:hide()
    self.canvas:hide()
end

return M
