local wezterm = require("wezterm") --[[@as Wezterm]]

--- Create a status bar at the top
---@param _ Window
---@param pane Pane
---@return table
local function segments_for_right_status(_, pane)
    local cwd_uri = pane:get_current_working_dir()
    local cwd = ""
    if type(cwd_uri) == "userdata" then
        cwd = cwd_uri.file_path
    end
    return {
        cwd,
        wezterm.strftime("%a %b %-d %H:%M"),
        os.getenv("USER") or os.getenv("USERNAME"),
        wezterm.hostname(),
    }
end

---Returns tab title, preferring a manually set title
---@param tab_info TabInformation
---@return string
local function tab_title(tab_info)
    local title = tab_info.tab_title

    if title and #title > 0 then
        return title
    end

    return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

    local color_scheme = config.resolved_palette
    local bg = wezterm.color.parse("#3E405A")
    local fg = wezterm.color.parse(color_scheme.foreground)

    local pos = tab.tab_index + 1
    local title = " " .. pos .. ": " .. tab_title(tab)
    title = wezterm.truncate_right(title, max_width - 2)

    if not tab.is_active then
        fg = wezterm.color.parse("#000000")
    end

    return {
        { Background = { Color = bg } },
        { Foreground = { Color = fg } },
        { Text = title },
        { Background = { Color = "None" } },
        { Foreground = { Color = bg } },
        { Text = SOLID_RIGHT_ARROW },
    }
end)

wezterm.on("update-status", function(window, pane)
    local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
    local segments = segments_for_right_status(window, pane)

    local color_scheme = window:effective_config().resolved_palette
    local bg = wezterm.color.parse(color_scheme.background)
    local fg = color_scheme.foreground

    local gradient_to, gradient_from = bg, nil
    local appearance = require("appearance")
    if appearance.is_dark() then
        gradient_from = gradient_to:lighten(0.2)
    else
        gradient_from = gradient_to:darken(0.2)
    end

    local gradient = wezterm.color.gradient({
        orientation = "Horizontal",
        colors = { gradient_from, gradient_to },
    }, #segments)

    local elements = {}

    for i, seg in ipairs(segments) do
        local is_first = i == 1

        if is_first then
            table.insert(elements, { Background = { Color = "none" } })
        end
        table.insert(elements, { Foreground = { Color = gradient[i] } })
        table.insert(elements, { Text = SOLID_LEFT_ARROW })

        table.insert(elements, { Background = { Color = gradient[i] } })
        table.insert(elements, { Foreground = { Color = fg } })
        table.insert(elements, { Text = " " .. seg .. " " })
    end

    window:set_right_status(wezterm.format(elements))
end)
