---@type string[]
local aliases = {}

---@type string[]
local menu_items = Sketchybar.query("default_menu_items")

for _, alias in ipairs(menu_items) do
    if alias:lower():match("cisco") then
        local item = Sketchybar.add("alias", alias, { position = "right" })
        table.insert(aliases, item.name)
    end
end
Sketchybar.add("bracket", "network", aliases, { background = { color = require("colors").bg2 } })
