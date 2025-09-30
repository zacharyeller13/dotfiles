local M = {}

-- Examine codepoints/bytes for selected chars.  Useful for weird chars
local copy_event_listener = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
    local flags = event:getFlags()
    if flags.cmd and event:getCharacters() == "c" then
        -- Delay until item is actually copied
        hs.timer.doAfter(0.1, function()
            ---@type string?
            local text = hs.pasteboard.getContents()
            if text then
                local codepoints = {}

                for _, c in utf8.codes(text) do
                    local ok, char = pcall(utf8.char, c)
                    if not ok then
                        char = "invalid unicode"
                    end
                    table.insert(codepoints, string.format("%s | %s", char, c))
                end
                hs.alert.show(table.concat(codepoints, "\n"), 3)
            end
        end)
    end
    return false
end)

M.copy_event_listener = copy_event_listener

return M
