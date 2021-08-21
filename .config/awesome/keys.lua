local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local util = require("util")
require("awful.hotkeys_popup.keys")

modkey = "Mod4"
altkey = "Mod1"
ctrlkey = "Control"
shiftkey = "Shift"

local keys = {}

keys.globalkeys = gears.table.join(
	awful.key(
		{modkey},
		"d",
		function()
			awful.spawn.with_shell("rofi -matching fuzzy -show combi")
		end,
		{description = "rofi launcher", group = "launcher"}
	),
	awful.key(
		{modkey},
		"s",
		hotkeys_popup.show_help,
		{description="show help", group="awesome"}
	),
	awful.key(
		{},
		"XF86AudioLowerVolume",
		function()
			util.volume_control(-5)
		end,
		{description = "lower volume", group = "volume"}
	),
	awful.key(
		{},
		"XF86AudioRaiseVolume",
		function()
			util.volume_control(5)
		end,
		{description = "raise volume", group = "volume"}
	),
	awful.key(
		{},
		"XF86MonBrightnessDown",
		function()
			awful.spawn.with_shell("light -U 10")
		end,
		{description = "raise brightness", group = "brightness"}
	),
	awful.key(
		{},
		"XF86MonBrightnessUp",
		function()
			awful.spawn.with_shell("light -A 10")
		end,
		{description = "lower brightness", group = "brightness"}
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
		{modkey, shiftkey},
		"h",
		function()
			awful.client.swap.bydirection("left")
		end,
		{description = "swap with window to the left", group = "client"}
	),
	awful.key(
		{modkey, shiftkey},
		"j",
		function()
			awful.client.swap.bydirection("down")
		end,
		{description = "swap with window below", group = "client"}
	),
	awful.key(
		{modkey, shiftkey},
		"j",
		function()
			awful.client.swap.bydirection("up")
		end,
		{description = "swap with window above", group = "client"}
	),
	awful.key(
		{modkey, shiftkey},
		"l",
		function()
			awful.client.swap.bydirection("right")
		end,
		{description = "swap with window to the right", group = "client"}
	),

	awful.key(
		{modkey, shiftkey},
		"minus",
		function()
			awful.tag.incgap(-5, nil)
		end,
		{description = "increment gaps size for the current tag", group = "gaps"}
	),
	awful.key(
		{modkey},
		"minus",
		function()
			awful.tag.incgap(5, nil)
		end,
		{description = "decrement gap size for the current tag", group = "gaps"}
	),

	awful.key(
		{modkey},
		"Return",
		function()
			awful.spawn("kitty -1")
		end,
		{description = "open a terminal", group = "launcher"}
	),
	awful.key(
		{modkey, ctrlkey},
		"r",
		awesome.restart,
		{description = "reload awesome", group = "awesome"}
	),

	awful.key(
		{modkey, ctrlkey},
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

keys.clientkeys = gears.table.join(
	awful.key({modkey},
		"f",
		function (c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end,
		{description = "toggle fullscreen", group = "client"}
	),
	awful.key(
		{modkey, shiftkey},
		"c",
		function(c)
			c:kill()
		end,
		{description = "close", group = "client"}
	),
	awful.key(
		{modkey, ctrlkey},
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
		{modkey, ctrlkey},
		"m",
		function (c)
			c.maximized_vertical = not c.maximized_vertical
			c:raise()
		end,
		{description = "(un)maximize vertically", group = "client"}
	),
	awful.key(
		{modkey, shiftkey},
		"m",
		function (c)
			c.maximized_horizontal = not c.maximized_horizontal
			c:raise()
		end,
		{description = "(un)maximize horizontally", group = "client"}
	)
)

for i = 1, 10 do
	keys.globalkeys = gears.table.join(keys.globalkeys,
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
			{modkey, shiftkey},
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
			{modkey, ctrlkey, shiftkey},
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

keys.clientbuttons = gears.table.join(
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

root.keys(keys.globalkeys)

return keys
