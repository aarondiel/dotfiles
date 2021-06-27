require("awful.autofocus")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")

local keys = require("keys")
local theme = require("theme")
beautiful.init(theme)

-- startup error handling
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors
	})
end

-- runtime error handling
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		if in_error then
			return
		end

		in_error = true
		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err)
		})
		in_error = false
	end)
end

-- variable definitions
awful.layout.layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.floating,
	awful.layout.suit.fair,
	awful.layout.suit.fair.horizontal,
}

local function set_wallpaper()
	awful.spawn.with_shell(os.getenv("HOME") .. "/.fehbg")
end

screen.connect_signal("property::geometry", set_wallpaper)
awful.screen.connect_for_each_screen(function(s)
	set_wallpaper()

	local layouts = {
		awful.layout.suit.fair,
		awful.layout.suit.fair,
		awful.layout.suit.fair,
		awful.layout.suit.fair,
		awful.layout.suit.fair,
		awful.layout.suit.fair,
		awful.layout.suit.fair,
		awful.layout.suit.fair,
		awful.layout.suit.fair,
		awful.layout.suit.fair,
	}

	local tagnames = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"}

	awful.tag(tagnames, s, layouts)
end)

-- rules
awful.rules.rules = {
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = keys.clientkeys,
			buttons = keys.clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap+awful.placement.no_offscreen
		}
	},
	{
		rule_any = {
			role = {
				"pop-up"
			}
		},
		properties = {floating = true}
	},
	{
		rule_any = {type = {"normal"}},
		properties = { titlebars_enabled = false }
	}
}

-- signals
client.connect_signal("manage", function(c)
	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		awful.placement.no_offscreen(c)
	end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
