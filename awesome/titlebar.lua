local awful = require('awful')
local wibox = require('wibox')

local function move_window(target_client)
	return function()
		client.focus = target_client
		target_client:raise()
		awful.mouse.client.move(target_client)
	end
end

client.connect_signal('request::titlebars', function(target_client)
	local buttons = {
		awful.button({}, 1, move_window(target_client))
	}

	local left_widgets = {
		buttons = buttons,
		layout = wibox.layout.fixed.horizontal,

		awful.titlebar.widget.iconwidget(target_client)
	}

	local middle_widgets = {
			buttons = buttons,
			layout = wibox.layout.flex.horizontal,

			{
				align = 'center',
				widget = awful.titlebar.widget.titlewidget(target_client)
			}
	}

	local right_widgets = {
		buttons = buttons,
		layout = wibox.layout.fixed.horizontal(),

		awful.titlebar.widget.floatingbutton(target_client),
		awful.titlebar.widget.maximizedbutton(target_client),
		awful.titlebar.widget.ontopbutton(target_client),
		awful.titlebar.widget.closebutton(target_client)
	}

	awful.titlebar(target_client).widget = {
		layout = wibox.layout.align.horizontal,

		left_widgets,
		middle_widgets,
		right_widgets
	}
end)