local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gfs = require("gears.filesystem")
local xrdb = xresources.get_current_theme()

local theme = {}

theme.font = "SourceCodePro 11"
theme.icon_theme = "/usr/share/icons/Papirus-Dark"

theme.bg_dark       = xrdb.background
theme.bg_normal     = xrdb.color0
theme.bg_focus      = xrdb.color8
theme.bg_urgent     = xrdb.color8
theme.bg_minimize   = xrdb.color8
theme.bg_systray    = xrdb.background

theme.fg_normal     = xrdb.color8
theme.fg_focus      = xrdb.color4
theme.fg_urgent     = xrdb.color9
theme.fg_minimize   = xrdb.color8

theme.useless_gap   = dpi(5)
theme.screen_margin = dpi(5)
theme.border_width  = dpi(0)
theme.border_color = xrdb.color0
theme.border_normal = xrdb.background
theme.border_focus  = xrdb.background
theme.border_radius = dpi(6)

theme.titlebars_enabled = false
theme.titlebar_size = dpi(32)
theme.titlebar_title_enabled = false
theme.titlebar_font = "sans bold 9"
theme.titlebar_title_align = "center"
theme.titlebar_position = "top"
theme.titlebar_bg = xrdb.color0
theme.titlebar_bg = xrdb.background
theme.titlebar_bg_focus = xrdb.color12
theme.titlebar_bg_normal = xrdb.color8
theme.titlebar_fg_focus = xrdb.background
theme.titlebar_fg_normal = xrdb.color8

theme.notification_position = "top_right"
theme.notification_border_width = dpi(0)
theme.notification_border_radius = theme.border_radius
theme.notification_border_color = xrdb.color10
theme.notification_bg = xrdb.background
-- theme.notification_bg = xrdb.color8
theme.notification_fg = xrdb.foreground
theme.notification_crit_bg = xrdb.background
theme.notification_crit_fg = xrdb.color1
theme.notification_icon_size = dpi(60)
-- theme.notification_height = dpi(80)
-- theme.notification_width = dpi(300)
theme.notification_margin = dpi(16)
theme.notification_opacity = 1
theme.notification_font = "sans 12"
theme.notification_padding = theme.screen_margin * 2
theme.notification_spacing = theme.screen_margin * 2

-- Edge snap
theme.snap_shape = gears.shape.rectangle
theme.snap_bg = xrdb.foreground
theme.snap_border_width = dpi(3)

-- Widget separator
theme.separator_text = "|"
theme.separator_fg = xrdb.color8

-- Wibar(s)
-- Keep in mind that these settings could be ignored by the bar theme
theme.wibar_position = "bottom"
theme.wibar_height = dpi(32)
theme.wibar_fg = xrdb.color7
theme.wibar_bg = xrdb.background
--theme.wibar_opacity = 0.7
theme.wibar_border_color = xrdb.color0
theme.wibar_border_width = dpi(0)
theme.wibar_border_radius = dpi(0)
theme.wibar_width = dpi(700)

theme.prefix_fg = xrdb.color8

 --Tasklist
theme.tasklist_font = "sans medium 8"
theme.tasklist_disable_icon = true
theme.tasklist_plain_task_name = true
theme.tasklist_bg_focus = xrdb.color0
theme.tasklist_fg_focus = xrdb.foreground
theme.tasklist_bg_normal = "#00000000"
theme.tasklist_fg_normal = xrdb.foreground.."77"
theme.tasklist_bg_minimize = "#00000000"
theme.tasklist_fg_minimize = xrdb.color8
-- theme.tasklist_font_minimized = "sans italic 8"
theme.tasklist_bg_urgent = xrdb.background
theme.tasklist_fg_urgent = xrdb.color3
theme.tasklist_spacing = dpi(0)
theme.tasklist_align = "center"

-- Sidebar
-- (Sidebar items can be customized in sidebar.lua)
theme.sidebar_bg = xrdb.background
theme.sidebar_fg = xrdb.color7
theme.sidebar_opacity = 1
theme.sidebar_position = "left" -- left or right
theme.sidebar_width = dpi(300)
theme.sidebar_x = 0
theme.sidebar_y = 0
theme.sidebar_border_radius = 0
-- theme.sidebar_border_radius = theme.border_radius

-- Exit screen
theme.exit_screen_bg = xrdb.color0 .. "CC"
theme.exit_screen_fg = xrdb.color7
theme.exit_screen_font = "sans 20"
theme.exit_screen_icon_size = dpi(180)

-- Lock screen
theme.lock_screen_bg = xrdb.color0 .. "CC"
theme.lock_screen_fg = xrdb.color7

-- Prompt
theme.prompt_fg = xrdb.color12

theme.menu_height = dpi(35)
theme.menu_width  = dpi(180)
theme.menu_bg_normal = xrdb.color0
theme.menu_fg_normal= xrdb.color7
theme.menu_bg_focus = xrdb.color8 .. "55"
theme.menu_fg_focus= xrdb.color7
theme.menu_border_width = dpi(0)
theme.menu_border_color = xrdb.color0

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

return theme
