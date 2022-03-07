local gears = require('gears')
local beautiful = require('beautiful')

screen.connect_signal('request::wallpaper', function(target_screen)
	local file = gears.filesystem.get_random_file_from_dir(
		beautiful.wallpaper,
		{ '.jpg', '.png' },
		true
	)

	gears.wallpaper.maximized(file, target_screen)
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
