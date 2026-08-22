-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")
--
local mainMod = "SUPER"

hl.unbind(mainMod .. " + RETURN") -- default = launch term
hl.unbind(mainMod .. " + T")      -- default = toggle float/tile
-- copy omarchy binding, since we have wezterm set as default
o.bind(mainMod .. " + T", "Terminal", { omarchy = "terminal" })

-- browser, haven't found a way to set as the default
hl.unbind(mainMod .. " SHIFT + B")
o.bind(mainMod .. " + B", "Browser", o.launch("glide-bin"))

-- close windows
hl.unbind(mainMod .. " + W")
o.bind(mainMod .. " + C", "[C]lose window", hl.dsp.window.close())

-- Move focus with mainMod + arrow keys
hl.unbind(mainMod .. " + L")
o.bind(mainMod .. " + H", "Focus left", hl.dsp.focus({ direction = "left" }))
o.bind(mainMod .. " + L", "Focus right", hl.dsp.focus({ direction = "right" }))
o.bind(mainMod .. " + K", "Focus up", hl.dsp.focus({ direction = "up" }))
hl.unbind(mainMod .. " + J")
o.bind(mainMod .. " + J", "Focus down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.swap({ direction = "right" }))

-- Toggle split
o.bind(mainMod .. " + SHIFT + J", "Toggle window split", hl.dsp.layout("togglesplit"))

-- Fullscreen
hl.unbind(mainMod .. " + F")
o.bind(mainMod .. " + M", "Toggle fullscreen", hl.dsp.window.fullscreen())
