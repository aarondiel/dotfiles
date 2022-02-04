local awful = require('awful')

tag.connect_signal('request::default_layouts', function()
	awful.layout.append_default_layouts({
		awful.layout.suit.tile.left,
		awful.layout.suit.max,
		awful.layout.suit.magnifier,
		awful.layout.suit.corner.nw,
		awful.layout.suit.floating
	})
end)

-- target_screen: awful.screen
local function setup_tags(target_screen)
	awful.tag(
		{ '', '', '', '4', '5', '6', '7', '8', '9' },
		target_screen,
		awful.layout.layouts[1]
	)
end

return setup_tags
