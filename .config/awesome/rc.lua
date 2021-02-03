local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
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
terminal = "kitty -1"
editor = "nvim"
editor_cmd = terminal .. " -e " .. editor
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
		rule = { },
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
			instance = {
				"DTA",	-- Firefox addon DownThemAll.
				"copyq",	-- Includes session name in class.
				"pinentry",
			},
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin",  -- kalarm.
				"Sxiv",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui",
				"veromix",
				"xtightvncviewer"
			},

			name = {
				"Event Tester",  -- xev.
			},
			role = {
				"AlarmWindow",	-- Thunderbird's calendar.
				"ConfigManager",	-- Thunderbird's about:config.
				"pop-up",		  -- e.g. Google Chrome's (detached) Developer Tools.
			}
	},
	properties = {floating = true}},

	{
		rule_any = {type = {"normal", "dialog"}},
		properties = { titlebars_enabled = true }
	}
}

-- signals
client.connect_signal("manage", function(c)
	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		awful.placement.no_offscreen(c)
	end
end)

-- titlebar
client.connect_signal("request::titlebars", function(c)
	local buttons = gears.table.join(
		awful.button({}, 1, function()
			c:emit_signal("request::activate", "titlebar", {raise = true})
			awful.mouse.client.move(c)
		end),
		awful.button({}, 3, function()
			c:emit_signal("request::activate", "titlebar", {raise = true})
			awful.mouse.client.resize(c)
		end)
	)

	awful.titlebar(c):setup {
		{ -- left
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout	= wibox.layout.fixed.horizontal
		},
		{ -- middle
			{ -- title
				align  = "center",
				widget = awful.titlebar.widget.titlewidget(c)
			},
			buttons = buttons,
			layout	= wibox.layout.flex.horizontal
		},
		{ -- right
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.closebutton	 (c),
			layout = wibox.layout.fixed.horizontal()
		},
		layout = wibox.layout.align.horizontal
	}
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
