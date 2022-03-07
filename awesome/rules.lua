--- @module 'awful.init'
local awful = require('awful')
local naughty = require('naughty')
local beautiful = require('beautiful')
local mappings = require('mappings')
local dpi = beautiful.xresources.apply_dpi

--- @param target_client awful.client
--- @return awful.placement
local function floating_client_placement(target_client)
	local layout_floating = awful.layout.get(mouse.screen) ~= awful.layout.suit.floating
	local no_visible_clients = #mouse.screen.clients == 1

	if (layout_floating or no_visible_clients) then
		return awful.placement.centered(
			target_client,
			{ honor_padding = true, honor_workarea = true }
		)
	end

	local placement = awful.placement.no_overlap + awful.placement.no_offscreen
	return placement(target_client, {
		honor_padding = true,
		honor_workarea=true,
		margins = beautiful.useless_gap * 2
	})
end

naughty.config = {
	padding = dpi(4),
	spacing = dpi(1),
	icon_dirs = { 'usr/share/pixmaps' },
	icon_formats = { 'png' },
	notify_callback = nil,
	presets = {
		low = {
			timeout = 5
		},

		normal = {},

		critical = {
			bg = '#ff0000',
			fg = '#ffffff',
			timeout = 0
		}
	},

	defaults = {
		timeout = 5,
		text = '',
		screen = awful.screen.focused,
		ontop = true,
		margin = dpi(5),
		border_width = dpi(1),
		position = 'top_right'
	}
}

local global_client_config = {
	rule = {},
	properties = {
		border_width = beautiful.border_width,
		border_color = beautiful.border_normal,
		focus = awful.client.focus.filter,
		raise = true,

		keys = mappings.client_keys,
		buttons = mappings.client_buttons,

		screen = awful.screen.focused,
		size_hints_honor = false,
		honor_workarea = true,
		honor_padding = true,
		maximized = false,
		titlebars_enabled = true,
		maximized_horizontal = false,
		maximized_vertical = false,
		placement = floating_client_placement
	}
}

awful.rules.rules = {
	global_client_config
}
