local ruled = require('ruled')
local awful = require('awful')

ruled.client.connect_signal('request::rules', function()
	ruled.client.append_rule {
		id = 'global',
		rule = { },
		properties = {
			focus = awful.client.focus.filter,
			raise = true,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap+awful.placement.no_offscreen
		}
	}

	-- use xprop to get a window's class
	ruled.client.append_rule {
		id = 'floating',
		rule_any = {
			instance = { 'copyq', 'pinentry' },
			class	 = {
				'Blueman-manager'
			},

			name	= {
				-- xev
				'Event Tester'
			},
			role	= {
				-- Thunderbird's calendar
				'AlarmWindow',
				-- Thunderbird's about:config
				'ConfigManager',
				-- e.g. Google Chrome's (detached) Developer Tools
				'pop-up',
			}
		},
		properties = { floating = true }
	}

	ruled.client.append_rule {
		id = 'titlebars',
		rule_any = { type = { 'normal', 'dialog' } },
		properties = { titlebars_enabled = true	}
	}
end)


ruled.notification.connect_signal('request::rules', function()
	ruled.notification.append_rule({
		rule = { urgency = 'critical' },
		properties = { bg = '#ff0000', fg = '#ffffff' }
	})

	ruled.notification.append_rule({
		rule = { },
		properties = {
			screen = awful.screen.preferred,
			implicit_timeout = 5
		}
	})
end)
