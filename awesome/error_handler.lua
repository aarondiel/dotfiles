local naughty = require('naughty')

naughty.connect_signal('request::display_error', function(message, startup)
	local error_message = 'an error occured'
	if startup == true then
		error_message = error_message .. ' during startup'
	end

	naughty.notification {
		urgency = 'critical',
		title	= error_message,
		message = message
	}
end)
