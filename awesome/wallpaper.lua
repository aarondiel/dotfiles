local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')

screen.connect_signal('request::wallpaper', function(target_screen)
	awful.wallpaper({
		screen = target_screen,
		widget = {
			{
				image = gears.filesystem.get_random_file_from_dir(
					beautiful.wallpaper,
					{ '.jpg', '.png' },
					true
				),
				resize = true,
				widget = wibox.widget.imagebox
			},
			valign = 'center',
			halign = 'center',
			tiled  = false,
			widget = wibox.container.tile
		}
	})
end)

gears.timer({
	timeout = 10 * 60,
	autostart = true,
	callback = function()
		for target_screen in screen do
			target_screen:emit_signal('request::wallpaper')
		end
	end
})
