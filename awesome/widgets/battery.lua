--- @module 'wibox.init'
local wibox = require('wibox')

--- @module 'awful.init'
local awful = require('awful')

--- @module 'gears.init'
local gears = require('gears')

--- @class Output
--- @field stdout string
--- @field stderr string
--- @field exitreason string
--- @field exitcode integer

--- @param widget awful.widget
--- @param tooltip awful.tooltip
--- @param output Output
--- @return nil
local function update_battery_widget(widget, tooltip, output)
	local fields = gears.string.split(output.stdout:sub(1, -2), '\n')
	local percentage = 0
	local charging = false

	if (#fields == 3) then
		charging = fields[1] ~= 'discharging'
		local time_until_discharged = fields[2]
		percentage = tonumber(fields[3]:sub(1, -2))

		tooltip:set_text(time_until_discharged)
	else
		charging = fields[1] ~= 'discharging'
		percentage = tonumber(fields[2]:sub(1, -2))
	end

	widget:set_text(tostring(percentage) .. '%')
end

--- @param tooltip awful.tooltip
--- @param callback fun(widget: awful.widget, tooltip: awful.tooltip, output: Output): nil
--- @return fun(widget: awful.widget, stdout: string, stderr: string, exitreason: string, exitcode: integer)
local function wrap_update_battery_widget(tooltip, callback)
	--- @param widget awful.widget
	--- @param stdout string
	--- @param stderr string
	--- @param exitreason string
	--- @param exitcode string
	return function(widget, stdout, stderr, exitreason, exitcode)
		local output = {
			stdout = stdout,
			stderr = stderr,
			exitreason = exitreason,
			exitcode = exitcode
		}

		callback(widget, tooltip, output)
	end
end

--- @return awful.widget
local function create_battery_widget()
	local battery_widget = wibox.widget.textbox('?%')

	local battery_tooltip = awful.tooltip({})
	battery_tooltip:add_to_object(battery_widget)

	local command = [[ sh -c "
		upower -i $(upower -e | grep 'BAT') | awk -F ': +' 'match($1, /state|time to empty|percentage/) { print $2 }'
	"]]

	awful.widget.watch(
		command,
		15,
		wrap_update_battery_widget(battery_tooltip, update_battery_widget),
		battery_widget
	)

	return battery_widget
end

return create_battery_widget
