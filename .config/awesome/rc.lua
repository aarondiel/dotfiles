-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

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
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
terminal = "kitty -1"
editor = "nvim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"
awful.layout.layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.floating,
	awful.layout.suit.fair,
	awful.layout.suit.fair.horizontal,
}
mykeyboardlayout = awful.widget.keyboardlayout()

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

	local tagnames = beautiful.tagnames or {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"}

	awful.tag(tagnames, s, layouts)
end)

-- key bindings
globalkeys = gears.table.join(
	awful.key(
		{modkey},
		"s",
		hotkeys_popup.show_help,
		{description="show help", group="awesome"}
	),
	awful.key(
		{modkey},
		"h",
		function()
			awful.client.focus.bydirection("left")
		end,
		{description = "focus left", group = "client"}
	),
	awful.key(
		{modkey},
		"j",
		function()
			awful.client.focus.bydirection("down")
		end,
		{description = "focush", group = "client"}
	),
	awful.key(
		{modkey},
		"k",
		function()
			awful.client.focus.bydirection("up")
		end,
		{description = "focus window above", group = "client"}
	),
	awful.key(
		{modkey},
		"l",
		function()
			awful.client.focus.bydirection("right")
		end,
		{description = "focus window to the right", group = "client"}
	),

	awful.key(
		{modkey, "Shift"},
		"h",
		function()
			awful.client.swap.bydirection("left")
		end,
		{description = "swap with window to the left", group = "client"}
	),
	awful.key(
		{modkey, "Shift"},
		"j",
		function()
			awful.client.swap.bydirection("down")
		end,
		{description = "swap with window below", group = "client"}
	),
	awful.key(
		{modkey, "Shift"},
		"j",
		function()
			awful.client.swap.bydirection("up")
		end,
		{description = "swap with window above", group = "client"}
	),
	awful.key(
		{modkey, "Shift"},
		"l",
		function()
			awful.client.swap.bydirection("right")
		end,
		{description = "swap with window to the right", group = "client"}
	),

	awful.key(
		{modkey},
		"Return",
		function()
			awful.spawn(terminal)
		end,
		{description = "open a terminal", group = "launcher"}
	),
	awful.key(
		{modkey, "Control"},
		"r",
		awesome.restart,
		{description = "reload awesome", group = "awesome"}
	),

	awful.key(
		{modkey, "Control"},
		"n",
		function()
			local c = awful.client.restore()
			if c then
				c:emit_signal("request::activate", "key.unminimize", {raise = true})
			end
		end,
		{description = "restore minimized", group = "client"}
	)
)

clientkeys = gears.table.join(
	awful.key({modkey},
		"f",
		function (c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end,
		{description = "toggle fullscreen", group = "client"}
	),
	awful.key(
		{modkey, "Shift"},
		"c",
		function(c)
			c:kill()
		end,
		{description = "close", group = "client"}
	),
	awful.key(
		{modkey, "Control"},
		"space",
		awful.client.floating.toggle						,
		{description = "toggle floating", group = "client"}
	),
	awful.key(
		{modkey},
		"t",
		function(c)
			c.ontop = not c.ontop
		end,
		{description = "toggle keep on top", group = "client"}
	),
	awful.key(
		{modkey},
		"n",
		function (c)
			c.minimized = true
		end,
		{description = "minimize", group = "client"}
	),
	awful.key(
		{modkey},
		"m",
		function (c)
			c.maximized = not c.maximized
			c:raise()
		end ,
		{description = "(un)maximize", group = "client"}
	),
	awful.key(
		{modkey, "Control"},
		"m",
		function (c)
			c.maximized_vertical = not c.maximized_vertical
			c:raise()
		end,
		{description = "(un)maximize vertically", group = "client"}
	),
	awful.key(
		{modkey, "Shift"},
		"m",
		function (c)
			c.maximized_horizontal = not c.maximized_horizontal
			c:raise()
		end,
		{description = "(un)maximize horizontally", group = "client"}
	)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 10 do
	globalkeys = gears.table.join(globalkeys,
		awful.key(
			{modkey},
			"#" .. i + 9,
			function ()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					tag:view_only()
				end
			end,
			{description = "view tag #"..i, group = "tag"}
		),
		awful.key(
			{modkey, "Shift"},
			"#" .. i + 9,
			function ()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:move_to_tag(tag)
					end
				end
			end,
			{description = "move focused client to tag #"..i, group = "tag"}
		),
		awful.key(
			{modkey, "Control", "Shift"},
			"#" .. i + 9,
			function ()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:toggle_tag(tag)
					end
				end
			end,
			{description = "toggle focused client on tag #" .. i, group = "tag"}
		)
	)
end

clientbuttons = gears.table.join(
	awful.button({ }, 1, function (c)
		c:emit_signal("request::activate", "mouse_click", {raise = true})
	end),
	awful.button({ modkey }, 1, function (c)
		c:emit_signal("request::activate", "mouse_click", {raise = true})
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function (c)
		c:emit_signal("request::activate", "mouse_click", {raise = true})
		awful.mouse.client.resize(c)
	end)
)
root.keys(globalkeys)

-- rules
awful.rules.rules = {
	{
		rule = { },
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
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
