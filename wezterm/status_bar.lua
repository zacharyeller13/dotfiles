local wezterm = require("wezterm") --[[@as Wezterm]]

---Create a status bar at the bottom
---@param _ Window
---@param pane Pane
---@return table #Segments to show in right status
local function segments_for_right_status(_, pane)
    -- We are always on a version where cwd is a Url (unless we're in a non-local domain)
    local cwd_uri = pane:get_current_working_dir() --[[@as Url]]
    local cwd = cwd_uri and cwd_uri.file_path or ""

    local domain = pane:get_domain_name()
    if domain == "local" then
        domain = wezterm.hostname()
    end
    return {
        cwd,
        wezterm.strftime("%a %b %-d %H:%M"),
        os.getenv("USER") or os.getenv("USERNAME"),
        domain,
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
    local edge_bg = wezterm.color.parse(color_scheme.background)

    local pos = tab.tab_index + 1
    local title = " " .. pos .. ": " .. tab_title(tab)
    title = wezterm.truncate_right(title, max_width - 1)

    if not tab.is_active then
        fg = wezterm.color.parse("#000000")
    end

    return {
        { Background = { Color = bg } },
        { Foreground = { Color = fg } },
        { Text = title },
        { Background = { Color = edge_bg } },
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

    local right_status = {}
    for i, seg in ipairs(segments) do
        local is_first = i == 1

        if is_first then
            table.insert(right_status, { Background = { Color = bg } })
        end
        table.insert(right_status, { Foreground = { Color = gradient[i] } })
        table.insert(right_status, { Text = SOLID_LEFT_ARROW })

        table.insert(right_status, { Background = { Color = gradient[i] } })
        table.insert(right_status, { Foreground = { Color = fg } })
        table.insert(right_status, { Text = " " .. seg .. " " })
    end

    local left_status = {}
    table.insert(left_status, { Background = { Color = bg } })
    table.insert(left_status, { Foreground = { Color = fg } })
    table.insert(left_status, { Text = " " .. window:active_workspace() .. " " })

    window:set_left_status(wezterm.format(left_status))
    window:set_right_status(wezterm.format(right_status))
end)
