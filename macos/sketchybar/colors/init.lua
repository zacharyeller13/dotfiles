return {
    -- TokyoNight Night
    -- Source: https://github.com/folke/tokyonight.nvim/blob/main/lua/tokyonight/colors/night.lua
    black = 0xff16161e, -- #16161e
    white = 0xffc0caf5, -- #c0caf5
    red = 0xfff7768e, -- #f7768e
    green = 0xff9ece6a, -- #9ece6a
    blue = 0xff7aa2f7, -- #7aa2f7
    yellow = 0xffe0af68, -- #e0af68
    orange = 0xffff9e64, -- #ff9e64
    magenta = 0xffbb9af7, -- #bb9af7
    grey = 0xff565f89, -- #565f89
    transparent = 0x00000000, -- #000000

    space = {
        active = 0xff7aa2f7, -- #7aa2f7
        inactive = 0xff565f89, -- #565f89
    },

    bar = {
        -- Note: bar.lua does not currently pass color = colors.bar.bg,
        -- so this value only takes effect if you add it there.
        bg = 0xb01a1b26, -- #1a1b26
        border = 0xff7aa2f7, -- #7aa2f7
    },

    popup = {
        bg = 0xff16161e, -- #16161e
        border = 0xff565f89, -- #565f89
        text = 0xffc0caf5, -- #c0caf5
    },

    bg1 = 0x801a1b26, -- #1a1b26
    bg2 = 0xff292e42, -- #292e42
    volume_slider_bg = 0xff3b4261, -- #3b4261
}
