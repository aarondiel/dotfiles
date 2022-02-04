local awful = require('awful')
local wibox = require('wibox')
local utils = require('utils')

-- target_screen: awful.screen
local function setup_wibar(target_screen)
	local tag_list = awful.widget.taglist({
		screen = target_screen,
		filter = awful.widget.taglist.filter.all,
		buttons = {
			awful.button({}, 1, utils.switch_to_tag)
		}
	})

	local tasklist = awful.widget.tasklist({
		screen = target_screen,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = {
			awful.button({}, 1, function (c)
				c:activate({ context = 'tasklist', action = 'toggle_minimization' })
			end),
			awful.button({}, 3, function()
				awful.menu.client_list({ theme = { width = 250 } })
			end)
		}
	})

	local layout_box = awful.widget.layoutbox {
		screen = target_screen,
		buttons = {
			awful.button({}, 1, utils.cycle_layouts(1)),
			awful.button({}, 3, utils.cycle_layouts(-1))
		}
	}

	local left_widgets = {
		layout = wibox.layout.fixed.horizontal,
		tag_list
	}

	local right_widgets = {
		layout = wibox.layout.fixed.horizontal,
		awful.widget.keyboardlayout(),
		wibox.widget.systray(),
		wibox.widget.textclock(),
		layout_box,
	}

	awful.wibar({
		position = 'top',
		screen = target_screen,
		widget = {
			layout = wibox.layout.align.horizontal,
			left_widgets,
			tasklist,
			right_widgets
		}
	})
end

return setup_wibar
