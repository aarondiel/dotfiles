require('awful.autofocus')
require('error_handler')
require('rules')
require('titlebar')

local beautiful = require('beautiful')
local naughty = require('naughty')
local setup_tags = require('tags')
local setup_wibar = require('wibar')
local utils = require('utils')

beautiful.init(utils.expand_path('~/.config/awesome/theme.lua'))
require('wallpaper')

screen.connect_signal('request::desktop_decoration', function(target_screen)
	setup_tags(target_screen)
	setup_wibar(target_screen)
end)

naughty.connect_signal('request::display', function(notification)
	naughty.layout.box({ notification = notification })
end)

client.connect_signal('mouse::enter', function(target_client)
	target_client:activate({ context = 'mouse_enter', raise = false })
end)
