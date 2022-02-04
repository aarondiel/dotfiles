local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local utils = require('utils')
local menu_height = dpi(15)
local theme = {}

-- color: string
-- selected: boolean
local function taglist_square(color, selected)
	assert(type(color) == 'string', 'invalid color for taglist_square_color')
	assert(type(selected) == 'boolean', 'invalid type for taglist_square_color')

	local taglist_square_function

	if selected then
		taglist_square_function = beautiful.theme_assets.taglist_squares_sel
	else
		taglist_square_function = beautiful.theme_assets.taglist_squares_unsel
	end

	return taglist_square_function(
		dpi(4),
		color
	)
end

theme.bg_normal = '#222222'
theme.fg_normal = '#aaaaaa'
theme.useless_gap = dpi(0)
theme.font = 'IBM Plex Mono:style=Bold 10'
theme.bg_focus = '#2d2d2f'
theme.bg_urgent = '#ff0000'
theme.bg_minimize = '#444444'
theme.bg_systray = theme.bg_normal
theme.fg_focus = '#ffffff'
theme.fg_urgent = '#ffffff'
theme.fg_minimize = '#ffffff'
theme.border_width = dpi(3)
-- theme.border_color = nil
theme.wallpaper = utils.expand_path('~/Pictures/wallpapers')
theme.border_color_marked = '#91231c'
-- theme.border_color_floating = nil
-- theme.border_color_maximized = nil
-- theme.border_color_fullscreen = nil
theme.border_color_active = '#3d3d3f'
theme.border_color_normal = '#000000'
-- theme.border_color_urgent = nil
-- theme.border_color_new = nil
-- theme.border_color_floating_active = nil
-- theme.border_color_floating_normal = nil
-- theme.border_color_floating_urgent = nil
-- theme.border_color_floating_new = nil
-- theme.border_color_maximized_active = nil
-- theme.border_color_maximized_normal = nil
-- theme.border_color_maximized_urgent = nil
-- theme.border_color_maximized_new = nil
-- theme.border_color_fullscreen_active = nil
-- theme.border_color_fullscreen_normal = nil
-- theme.border_color_fullscreen_urgent = nil
-- theme.border_color_fullscreen_new = nil
-- theme.border_width_floating = nil
-- theme.border_width_maximized = nil
-- theme.border_width_normal = nil
-- theme.border_width_active = nil
-- theme.border_width_urgent = nil
-- theme.border_width_new = nil
-- theme.border_width_floating_normal = nil
-- theme.border_width_floating_active = nil
-- theme.border_width_floating_urgent = nil
-- theme.border_width_floating_new = nil
-- theme.border_width_maximized_normal = nil
-- theme.border_width_maximized_active = nil
-- theme.border_width_maximized_urgent = nil
-- theme.border_width_maximized_new = nil
-- theme.border_width_fullscreen_normal = nil
-- theme.border_width_fullscreen_active = nil
-- theme.border_width_fullscreen_urgent = nil
-- theme.border_width_fullscreen_new = nil

-- theme.arcchart_border_color = nil
-- theme.arcchart_color = nil
-- theme.arcchart_border_width = nil
-- theme.arcchart_paddings = nil
-- theme.arcchart_thickness = nil

theme.awesome_icon = beautiful.theme_assets.awesome_icon(
	menu_height,
	theme.bg_focus,
	theme.fg_focus
)

-- theme.calendar_style = nil
-- theme.calendar_font = nil
-- theme.calendar_spacing = nil
-- theme.calendar_week_numbers = nil
-- theme.calendar_start_sunday = nil
-- theme.calendar_long_weekdays = nil

-- theme.checkbox_border_width = nil
-- theme.checkbox_bg = nil
-- theme.checkbox_border_color = nil
-- theme.checkbox_check_border_color = nil
-- theme.checkbox_check_border_width = nil
-- theme.checkbox_check_color = nil
-- theme.checkbox_shape = nil
-- theme.checkbox_check_shape = nil
-- theme.checkbox_paddings = nil
-- theme.checkbox_color = nil

-- theme.column_count = nil

-- theme.cursor_mouse_resize = nil
-- theme.cursor_mouse_move = nil

-- theme.enable_spawn_cursor = nil

-- theme.flex_height = nil

-- theme.fullscreen_hide_border = nil

-- theme.gap_single_client = nil

-- theme.graph_fg = nil
-- theme.graph_bg = nil
-- theme.graph_border_color = nil

-- theme.hotkeys_bg = nil
-- theme.hotkeys_fg = nil
-- theme.hotkeys_border_width = nil
-- theme.hotkeys_border_color = nil
-- theme.hotkeys_shape = nil
-- theme.hotkeys_modifiers_fg = nil
-- theme.hotkeys_label_bg = nil
-- theme.hotkeys_label_fg = nil
-- theme.hotkeys_font = nil
-- theme.hotkeys_description_font = nil
-- theme.hotkeys_group_margin = nil

theme.icon_theme = '/usr/share/icons/Papirus-Dark'

theme.layout_cornernw = utils.expand_path('$THEMES/default/layouts/cornernww.png')
theme.layout_cornerne = utils.expand_path('$THEMES/default/layouts/cornernew.png')
theme.layout_cornersw = utils.expand_path('$THEMES/default/layouts/cornersww.png')
theme.layout_cornerse = utils.expand_path('$THEMES/default/layouts/cornersew.png')
theme.layout_fairh = utils.expand_path('$THEMES/default/layouts/fairhw.png')
theme.layout_fairv = utils.expand_path('$THEMES/default/layouts/fairvw.png')
theme.layout_floating = utils.expand_path('$THEMES/default/layouts/floating.png')
theme.layout_magnifier = utils.expand_path('$THEMES/default/layouts/magnifierw.png')
theme.layout_max = utils.expand_path('$THEMES/default/layouts/maxw.png')
theme.layout_fullscreen = utils.expand_path('$THEMES/default/layouts/fullscreenw.png')
theme.layout_spiral  = utils.expand_path('$THEMES/default/layouts/spiralw.png')
theme.layout_dwindle = utils.expand_path('$THEMES/default/layouts/dwindlew.png')
theme.layout_tile = utils.expand_path('$THEMES/default/layouts/tilew.png')
theme.layout_tiletop = utils.expand_path('$THEMES/default/layouts/tiletopw.png')
theme.layout_tilebottom = utils.expand_path('$THEMES/default/layouts/tilebottomw.png')
theme.layout_tileleft   = utils.expand_path('$THEMES/default/layouts/tileleftw.png')

-- theme.layoutlist_fg_normal = nil
-- theme.layoutlist_bg_normal = nil
-- theme.layoutlist_fg_selected = nil
-- theme.layoutlist_bg_selected = nil
-- theme.layoutlist_disable_icon = nil
-- theme.layoutlist_disable_name = nil
-- theme.layoutlist_font = nil
-- theme.layoutlist_align = nil
-- theme.layoutlist_font_selected = nil
-- theme.layoutlist_spacing = nil
-- theme.layoutlist_shape = nil
-- theme.layoutlist_shape_border_width = nil
-- theme.layoutlist_shape_border_color = nil
-- theme.layoutlist_shape_selected = nil
-- theme.layoutlist_shape_border_width_selected = nil
-- theme.layoutlist_shape_border_color_selected = nil

-- theme.master_width_factor = nil
-- theme.master_fill_policy = nil
-- theme.master_count = nil

-- theme.maximized_honor_padding = nil
-- theme.maximized_hide_border = nil

theme.menu_submenu_icon = utils.expand_path('$THEMES/default/submenu.png')
-- theme.menu_font = nil
theme.menu_height = menu_height
theme.menu_width = dpi(100)
-- theme.menu_border_color = nil
-- theme.menu_border_width = nil
-- theme.menu_fg_focus = nil
-- theme.menu_bg_focus = nil
-- theme.menu_fg_normal = nil
-- theme.menu_bg_normal = nil
-- theme.menu_submenu = nil

-- theme.menubar_fg_normal = nil
-- theme.menubar_bg_normal = nil
-- theme.menubar_border_width = nil
-- theme.menubar_border_color = nil
-- theme.menubar_fg_focus = nil
-- theme.menubar_bg_focus = nil
-- theme.menubar_font = nil

-- theme.notification_max_width = nil
-- theme.notification_position = nil
-- theme.notification_action_underline_normal = nil
-- theme.notification_action_underline_selected = nil
-- theme.notification_action_icon_only = nil
-- theme.notification_action_label_only = nil
-- theme.notification_action_shape_normal = nil
-- theme.notification_action_shape_selected = nil
-- theme.notification_action_shape_border_color_normal = nil
-- theme.notification_action_shape_border_color_selected = nil
-- theme.notification_action_shape_border_width_normal = nil
-- theme.notification_action_shape_border_width_selected = nil
-- theme.notification_action_icon_size_normal = nil
-- theme.notification_action_icon_size_selected = nil
-- theme.notification_action_bg_normal = nil
-- theme.notification_action_bg_selected = nil
-- theme.notification_action_fg_normal = nil
-- theme.notification_action_fg_selected = nil
-- theme.notification_action_bgimage_normal = nil
-- theme.notification_action_bgimage_selected = nil
-- theme.notification_shape_normal = nil
-- theme.notification_shape_selected = nil
-- theme.notification_shape_border_color_normal = nil
-- theme.notification_shape_border_color_selected = nil
-- theme.notification_shape_border_width_normal = nil
-- theme.notification_shape_border_width_selected = nil
-- theme.notification_icon_size_normal = nil
-- theme.notification_icon_size_selected = nil
-- theme.notification_bg_normal = nil
-- theme.notification_bg_selected = nil
-- theme.notification_fg_normal = nil
-- theme.notification_fg_selected = nil
-- theme.notification_bgimage_normal = nil
-- theme.notification_bgimage_selected = nil
-- theme.notification_font = nil
-- theme.notification_bg = nil
-- theme.notification_fg = nil
-- theme.notification_border_width = nil
-- theme.notification_border_color = nil
-- theme.notification_shape = nil
-- theme.notification_opacity = nil
-- theme.notification_margin = nil
-- theme.notification_width = nil
-- theme.notification_height = nil
-- theme.notification_spacing = nil
-- theme.notification_icon_resize_strategy = nil

-- theme.opacity_normal = nil
-- theme.opacity_active = nil
-- theme.opacity_urgent = nil
-- theme.opacity_new = nil
-- theme.opacity_floating_normal = nil
-- theme.opacity_floating_active = nil
-- theme.opacity_floating_urgent = nil
-- theme.opacity_floating_new = nil
-- theme.opacity_maximized_normal = nil
-- theme.opacity_maximized_active = nil
-- theme.opacity_maximized_urgent = nil
-- theme.opacity_maximized_new = nil
-- theme.opacity_fullscreen_normal = nil
-- theme.opacity_fullscreen_active = nil
-- theme.opacity_fullscreen_urgent = nil
-- theme.opacity_fullscreen_new = nil

-- theme.piechart_border_color = nil
-- theme.piechart_border_width = nil
-- theme.piechart_colors = nil

-- theme.progressbar_bg = nil
-- theme.progressbar_fg = nil
-- theme.progressbar_shape = nil
-- theme.progressbar_border_color = nil
-- theme.progressbar_border_width = nil
-- theme.progressbar_bar_shape = nil
-- theme.progressbar_bar_border_width = nil
-- theme.progressbar_bar_border_color = nil
-- theme.progressbar_margins = nil
-- theme.progressbar_paddings = nil

-- theme.prompt_fg_cursor = nil
-- theme.prompt_bg_cursor = nil
-- theme.prompt_font = nil
-- theme.prompt_fg = nil
-- theme.prompt_bg = nil

-- theme.radialprogressbar_border_color = nil
-- theme.radialprogressbar_color = nil
-- theme.radialprogressbar_border_width = nil
-- theme.radialprogressbar_paddings = nil

-- theme.separator_thickness = nil
-- theme.separator_border_color = nil
-- theme.separator_border_width = nil
-- theme.separator_span_ratio = nil
-- theme.separator_color = nil
-- theme.separator_shape = nil

-- theme.slider_bar_border_width = nil
-- theme.slider_bar_border_color = nil
-- theme.slider_handle_border_color = nil
-- theme.slider_handle_border_width = nil
-- theme.slider_handle_width = nil
-- theme.slider_handle_color = nil
-- theme.slider_handle_shape = nil
-- theme.slider_bar_shape = nil
-- theme.slider_bar_height = nil
-- theme.slider_bar_margins = nil
-- theme.slider_handle_margins = nil
-- theme.slider_bar_color = nil
-- theme.slider_bar_active_color = nil

-- theme.snap_bg = nil
-- theme.snap_border_width = nil
-- theme.snap_shape = nil

-- theme.snapper_gap = nil

-- theme.systray_max_rows = nil
-- theme.systray_icon_spacing = nil

-- theme.taglist_fg_focus = nil
-- theme.taglist_bg_focus = nil
-- theme.taglist_fg_urgent = nil
-- theme.taglist_bg_urgent = nil
-- theme.taglist_bg_occupied = nil
-- theme.taglist_fg_occupied = nil
-- theme.taglist_bg_empty = nil
-- theme.taglist_fg_empty = nil
-- theme.taglist_bg_volatile = nil
-- theme.taglist_fg_volatile = nil
theme.taglist_squares_sel = taglist_square(theme.fg_normal, true)
theme.taglist_squares_unsel = taglist_square(theme.fg_normal, false)
-- theme.taglist_squares_sel_empty = nil
-- theme.taglist_squares_unsel_empty = nil
-- theme.taglist_squares_resize = nil
-- theme.taglist_disable_icon = nil
-- theme.taglist_font = nil
-- theme.taglist_spacing = nil
-- theme.taglist_shape = nil
-- theme.taglist_shape_border_width = nil
-- theme.taglist_shape_border_color = nil
-- theme.taglist_shape_empty = nil
-- theme.taglist_shape_border_width_empty = nil
-- theme.taglist_shape_border_color_empty = nil
-- theme.taglist_shape_focus = nil
-- theme.taglist_shape_border_width_focus = nil
-- theme.taglist_shape_border_color_focus = nil
-- theme.taglist_shape_urgent = nil
-- theme.taglist_shape_border_width_urgent = nil
-- theme.taglist_shape_border_color_urgent = nil
-- theme.taglist_shape_volatile = nil
-- theme.taglist_shape_border_width_volatile = nil
-- theme.taglist_shape_border_color_volatile = nil

-- theme.tasklist_fg_normal = nil
-- theme.tasklist_bg_normal = nil
-- theme.tasklist_fg_focus = nil
-- theme.tasklist_bg_focus = nil
-- theme.tasklist_fg_urgent = nil
-- theme.tasklist_bg_urgent = nil
-- theme.tasklist_fg_minimize = nil
-- theme.tasklist_bg_minimize = nil
-- theme.tasklist_bg_image_normal = nil
-- theme.tasklist_bg_image_focus = nil
-- theme.tasklist_bg_image_urgent = nil
-- theme.tasklist_bg_image_minimize = nil
-- theme.tasklist_disable_icon = nil
-- theme.tasklist_disable_task_name = nil
-- theme.tasklist_plain_task_name = nil
-- theme.tasklist_sticky = nil
-- theme.tasklist_ontop = nil
-- theme.tasklist_above = nil
-- theme.tasklist_below = nil
-- theme.tasklist_floating = nil
-- theme.tasklist_maximized = nil
-- theme.tasklist_maximized_horizontal = nil
-- theme.tasklist_maximized_vertical = nil
-- theme.tasklist_minimized = nil
theme.tasklist_font = theme.font
-- theme.tasklist_align = nil
-- theme.tasklist_font_focus = nil
-- theme.tasklist_font_minimized = nil
-- theme.tasklist_font_urgent = nil
-- theme.tasklist_spacing = nil
-- theme.tasklist_shape = nil
-- theme.tasklist_shape_border_width = nil
-- theme.tasklist_shape_border_color = nil
-- theme.tasklist_shape_focus = nil
-- theme.tasklist_shape_border_width_focus = nil
-- theme.tasklist_shape_border_color_focus = nil
-- theme.tasklist_shape_minimized = nil
-- theme.tasklist_shape_border_width_minimized = nil
-- theme.tasklist_shape_border_color_minimized = nil
-- theme.tasklist_shape_urgent = nil
-- theme.tasklist_shape_border_width_urgent = nil
-- theme.tasklist_shape_border_color_urgent = nil

-- theme.titlebar_fg_normal = nil
-- theme.titlebar_bg_normal = nil
-- theme.titlebar_bgimage_normal = nil
-- theme.titlebar_fg = nil
-- theme.titlebar_bg = nil
-- theme.titlebar_bgimage = nil
-- theme.titlebar_fg_focus = nil
-- theme.titlebar_bg_focus = nil
-- theme.titlebar_bgimage_focus = nil
-- theme.titlebar_fg_urgent = nil
-- theme.titlebar_bg_urgent = nil
-- theme.titlebar_bgimage_urgent = nil
-- theme.titlebar_floating_button_normal = nil
-- theme.titlebar_maximized_button_normal = nil
theme.titlebar_minimize_button_normal = utils.expand_path('$THEMES/default/titlebar/minimize_normal.png')
-- theme.titlebar_minimize_button_normal_hover = nil
-- theme.titlebar_minimize_button_normal_press = nil
theme.titlebar_close_button_normal = utils.expand_path('$THEMES/default/titlebar/close_normal.png')
-- theme.titlebar_close_button_normal_hover = nil
-- theme.titlebar_close_button_normal_press = nil
-- theme.titlebar_ontop_button_normal = nil
-- theme.titlebar_sticky_button_normal = nil
-- theme.titlebar_floating_button_focus = nil
-- theme.titlebar_maximized_button_focus = nil
theme.titlebar_minimize_button_focus = utils.expand_path('$THEMES/default/titlebar/minimize_focus.png')
-- theme.titlebar_minimize_button_focus_hover = nil
-- theme.titlebar_minimize_button_focus_press = nil
theme.titlebar_close_button_focus = utils.expand_path('$THEMES/default/titlebar/close_focus.png')
-- theme.titlebar_close_button_focus_hover = nil
-- theme.titlebar_close_button_focus_press = nil
-- theme.titlebar_ontop_button_focus = nil
-- theme.titlebar_sticky_button_focus = nil
theme.titlebar_floating_button_normal_active = utils.expand_path('$THEMES/default/titlebar/floating_normal_active.png')
-- theme.titlebar_floating_button_normal_active_hover = nil
-- theme.titlebar_floating_button_normal_active_press = nil
theme.titlebar_maximized_button_normal_active = utils.expand_path('$THEMES/default/titlebar/maximized_normal_active.png')
-- theme.titlebar_maximized_button_normal_active_hover = nil
-- theme.titlebar_maximized_button_normal_active_press = nil
theme.titlebar_ontop_button_normal_active = utils.expand_path('$THEMES/default/titlebar/ontop_normal_active.png')
-- theme.titlebar_ontop_button_normal_active_hover = nil
-- theme.titlebar_ontop_button_normal_active_press = nil
theme.titlebar_sticky_button_normal_active = utils.expand_path('$THEMES/default/titlebar/sticky_normal_active.png')
-- theme.titlebar_sticky_button_normal_active_hover = nil
-- theme.titlebar_sticky_button_normal_active_press = nil
theme.titlebar_floating_button_focus_active = utils.expand_path('$THEMES/default/titlebar/floating_focus_active.png')
-- theme.titlebar_floating_button_focus_active_hover = nil
-- theme.titlebar_floating_button_focus_active_press = nil
theme.titlebar_maximized_button_focus_active = utils.expand_path('$THEMES/default/titlebar/maximized_focus_active.png')
-- theme.titlebar_maximized_button_focus_active_hover = nil
-- theme.titlebar_maximized_button_focus_active_press = nil
theme.titlebar_ontop_button_focus_active = utils.expand_path('$THEMES/default/titlebar/ontop_focus_active.png')
-- theme.titlebar_ontop_button_focus_active_hover = nil
-- theme.titlebar_ontop_button_focus_active_press = nil
theme.titlebar_sticky_button_focus_active = utils.expand_path('$THEMES/default/titlebar/sticky_focus_active.png')
-- theme.titlebar_sticky_button_focus_active_hover = nil
-- theme.titlebar_sticky_button_focus_active_press = nil
theme.titlebar_floating_button_normal_inactive = utils.expand_path('$THEMES/default/titlebar/floating_normal_inactive.png')
-- theme.titlebar_floating_button_normal_inactive_hover = nil
-- theme.titlebar_floating_button_normal_inactive_press = nil
theme.titlebar_maximized_button_normal_inactive = utils.expand_path('$THEMES/default/titlebar/maximized_normal_inactive.png')
-- theme.titlebar_maximized_button_normal_inactive_hover = nil
-- theme.titlebar_maximized_button_normal_inactive_press = nil
theme.titlebar_ontop_button_normal_inactive = utils.expand_path('$THEMES/default/titlebar/ontop_normal_inactive.png')
-- theme.titlebar_ontop_button_normal_inactive_hover = nil
-- theme.titlebar_ontop_button_normal_inactive_press = nil
theme.titlebar_sticky_button_normal_inactive = utils.expand_path('$THEMES/default/titlebar/sticky_normal_inactive.png')
-- theme.titlebar_sticky_button_normal_inactive_hover = nil
-- theme.titlebar_sticky_button_normal_inactive_press = nil
theme.titlebar_floating_button_focus_inactive = utils.expand_path('$THEMES/default/titlebar/floating_focus_inactive.png')
-- theme.titlebar_floating_button_focus_inactive_hover = nil
-- theme.titlebar_floating_button_focus_inactive_press = nil
theme.titlebar_maximized_button_focus_inactive = utils.expand_path('$THEMES/default/titlebar/maximized_focus_inactive.png')
-- theme.titlebar_maximized_button_focus_inactive_hover = nil
-- theme.titlebar_maximized_button_focus_inactive_press = nil
theme.titlebar_ontop_button_focus_inactive = utils.expand_path('$THEMES/default/titlebar/ontop_focus_inactive.png')
-- theme.titlebar_ontop_button_focus_inactive_hover = nil
-- theme.titlebar_ontop_button_focus_inactive_press = nil
theme.titlebar_sticky_button_focus_inactive = utils.expand_path('$THEMES/default/titlebar/sticky_focus_inactive.png')
-- theme.titlebar_sticky_button_focus_inactive_hover = nil
-- theme.titlebar_sticky_button_focus_inactive_press = nil

-- theme.tooltip_border_color = nil
-- theme.tooltip_bg = nil
-- theme.tooltip_fg = nil
-- theme.tooltip_font = nil
-- theme.tooltip_border_width = nil
-- theme.tooltip_opacity = nil
-- theme.tooltip_gaps = nil
-- theme.tooltip_shape = nil
-- theme.tooltip_align = nil

-- theme.wallpaper_bg = nil
-- theme.wallpaper_fg = nil

-- theme.wibar_stretch = nil
-- theme.wibar_favor_vertical = nil
-- theme.wibar_border_width = nil
-- theme.wibar_border_color = nil
-- theme.wibar_ontop = nil
-- theme.wibar_cursor = nil
-- theme.wibar_opacity = nil
-- theme.wibar_type = nil
-- theme.wibar_width = nil
-- theme.wibar_height = nil
-- theme.wibar_bg = nil
-- theme.wibar_bgimage = nil
-- theme.wibar_fg = nil
-- theme.wibar_shape = nil
-- theme.wibar_margins = nil
-- theme.wibar_align = nil

return theme
