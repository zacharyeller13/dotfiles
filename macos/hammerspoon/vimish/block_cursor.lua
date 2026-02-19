-- vimish/block_cursor.lua
-- Block cursor functionality for Normal mode in Outlook (toggle-able)

---@class BlockCursor
---@field canvas hs.canvas
local M = {}
M.__index = M

function M.new()
    local canvas = hs.canvas.new({ w = 1, h = 1, x = 0, y = 0 })
    assert(canvas ~= nil, "Canvas was nil???")

    -- canvas:level("overlay")
    canvas:appendElements({
        type = "rectangle",
        action = "fill",
        fillColor = { red = 5, green = 5, blue = 5, alpha = 0.7 },
        frame = { x = "0%", y = "0%", h = "100%", w = "100%" },
        roundedRectRadii = { xRadius = 2, yRadius = 2 },
    })
    return setmetatable({ canvas = canvas }, M)
end

function M:show()
    self:hide() -- to hide existing cursor before re-rendering
    self:render_cursor()
end

function M:hide()
    if self.canvas:isShowing() then
        self.canvas:hide()
        return
    end
end

---@param element hs.axuielement
---@param depth? integer
---@return hs.axuielement?
local function find_text_area(element, depth)
    depth = depth or 0
    -- Prevent infinite recursion leading to stackoverflow
    if depth > 3 then
        return
    end
    local role = element:attributeValue("AXRole")
    if role == "AXTextArea" or role == "AXTextField" then
        return element
    end
    for _, v in ipairs(element) do
        local found = find_text_area(v, depth + 1)
        if found then
            print(depth, element, "found")
            return found
        end
    end
end

function M:render_cursor()
    local focused = hs.axuielement.systemWideElement():attributeValue("AXFocusedUIElement")
    if not focused then
        return
    end

    local text_area = find_text_area(focused)
    if not text_area then
        return
    end

    local selection_range = text_area:attributeValue("AXSelectedTextRange")
    if not selection_range then
        return
    end

    local bounds =
        text_area:parameterizedAttributeValue("AXBoundsForRange", { location = selection_range.location, length = 1 })
    if not bounds then
        return
    end

    self.canvas:topLeft({ x = bounds.x, y = bounds.y })
    self.canvas:size({ h = bounds.h, w = bounds.w })
    self.canvas:show()
end

return M
