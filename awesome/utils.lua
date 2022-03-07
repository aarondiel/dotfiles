local utils = {}
--- @module 'awful.init'
local awful = require('awful')
--- @module 'gears.init'
local gears = require('gears')
--- @module 'naughty.init'
local naughty = require('naughty')

--- @param path string
--- @return string
function utils.expand_path(path)
	assert(type(path) == 'string', 'invalid path for expand_path')

	local split = gears.string.split(path, '/')
	local starting_dir = table.remove(split, 1)

	if starting_dir == '~' then
		starting_dir = '$HOME'
	end

	if string.sub(starting_dir, 1, 1) ~= '$' then
		goto continue
	end

	if starting_dir == '$THEMES' then
		starting_dir = string.sub(
			gears.filesystem.get_themes_dir(),
			1,
			-2
		)

		goto continue
	end

	starting_dir = os.getenv(string.sub(starting_dir, 2))

	::continue::

	table.insert(split, 1, starting_dir)

	return table.concat(split, '/')
end


--- @return nil
function utils.open_terminal()
	awful.spawn('kitty -1')
end

--- @reutrn nil
function utils.open_rofi()
	awful.spawn('rofi -show run')
end

--- @param direction 'left' | 'up' | 'right' | 'down'
--- @reutrn fun(): nil
function utils.focus_window(direction)
	assert(
		direction == 'left' or
		direction == 'up' or
		direction == 'right' or
		direction == 'down',
		'unsupported direction for focus_window'
	)

	return function()
		awful.client.focus.bydirection(direction)
	end
end

--- @param direction 'left' | 'up' | 'right' | 'down'
--- @reutrn fun(): nil
function utils.swap_window(direction)
	assert(
		direction == 'left' or
		direction == 'up' or
		direction == 'right' or
		direction == 'down',
		'unsupported direction for focus_window'
	)

	return function()
		awful.client.swap.bydirection(direction)
	end
end

--- @param direction 1 | -1
--- @reutrn fun(): nil
function utils.cycle_window(direction)
	assert(
		direction == 1 or direction == -1,
		'unsupported direction for cycle_window'
	)

	return function()
		awful.client.focus.byidx(direction)
	end
end

--- @param direction 'left' | 'up' | 'right' | 'down'
--- @return fun(): nil
function utils.focus_screen(direction)
	assert(
		direction == 'left' or
		direction == 'up' or
		direction == 'right' or
		direction == 'down',
		'unsupported direction for focus_screen'
	)

	return function()
		awful.screen.focus_bydirection(direction)
	end
end

--- @param direction 'left' | 'up' | 'right' | 'down'
--- @return fun(): nil
function utils.move_to_screen(direction)
	assert(
		direction == 'left' or
		direction == 'up' or
		direction == 'right' or
		direction == 'down',
		'unsupported direction for focus_screen'
	)

	return function()
		local target_screen = awful.screen.focused()
			:get_next_in_direction('direction')

		if not target_screen or not client.focus then
			return
		end

		client.focus:move_to_screen(target_screen)
	end
end

-- TODO: pipe unminimized clients into rofi and select from there
--- @return nil
function utils.restore_minimized()
	-- client: awful.client
	local function minimized_client(target_client)
		return target_client.minimized
	end

	for target_client in awful.client.iterate(minimized_client) do
		target_client:activate({
			context = 'unminimize',
			raise = true
		})
	end
end

--- @param direction: 1 | -1
--- @return fun(): nil
function utils.cycle_layouts(direction)
	assert(
		direction == 1 or direction == -1,
		'unsupported direction for cycle_layouts'
	)

	return function()
		awful.layout.inc(direction)
	end
end

--- @param value integer
--- @return fun(): nil
function utils.change_gap(value)
	assert(
		type(value) == 'number',
		'invalid value for change_gap'
	)

	return function()
		awful.tag.incgap(value, nil)
	end
end

--- @param step integer
--- @return fun(): nil
function utils.change_volume(step)
	assert(
		type(step) == 'number',
		'step not valid for change_volume'
	)

	step = math.floor(step)
	local command = ''

	if step == 0 then
		return function()
			awful.spawn.with_shell('pactl set-sink-mute @DEFAULT_SINK@ toggle')
		end
	end

	local sign = ''
	if step < 0 then
		sign = ''
	else
		sign = '+'
	end

	command = 'pactl set-sink-volume @DEFAULT_SINK@ ' .. sign .. tostring(step) .. '%'

	return function()
		awful.spawn.with_shell(command)
	end
end

--- @param step integer
--- @return fun(): nil
function utils.change_brightness(step)
	assert(
		type(step) == 'number',
		'step not valid for change_brightness'
	)

	step = math.floor(step)
	local command = 'light '

	if step < 0 then
		command = command .. '-U'
	else
		command = command .. '-A'
	end

	step = math.abs(step)
	command = command .. ' ' .. tostring(step)

	return function()
		awful.spawn.with_shell(command)
	end
end

--- @param taget_tag awful.tag
--- @return fun(): nil
function utils.switch_to_tag(target_tag)
	return function()
		target_tag:view_only()
	end
end

--- @param index integer
--- @return fun(): nil
function utils.switch_to_tag_index(index)
	assert(
		index >= 1 and index <= 9,
		'index out of range for switch_to_tag'
	)

	return function()
		local screen = awful.screen.focused()
		local tag = screen.tags[index]

		tag:view_only()
	end
end

--- @param index integer
--- @return fun(): nil
function utils.move_to_tag(index)
	assert(
		index >= 1 and index <= 9,
		'index out of range for move_to_tag'
	)

	return function()
		if not client.focus then
			return
		end

		local tag = client.focus.screen.tags[index]
		if not tag then
			return
		end

		client.focus:move_to_tag(tag)
	end
end

--- @param target_client awful.client
--- @return nil
function utils.toggle_fullscreen(target_client)
	target_client.fullscreen = not target_client.fullscreen
	target_client:raise()
end

--- @param target_client: awful.client
--- @return nil
function utils.toggle_maximized(target_client)
	target_client.maximized = not target_client.maximized
	target_client:raise()
end

--- @param target_client: awful.client
--- @return nil
function utils.close_window(target_client)
	target_client:kill()
end

--- @param target_client: awful.client
--- @return nil
function utils.move_to_master(target_client)
	target_client:swap(awful.client.getmaster())
end

--- @param target_client: awful.client
--- @return nil
function utils.keep_window_on_top(target_client)
	target_client.ontop = not target_client.ontop
	target_client.raise()
end

--- @param target_client: awful.client
--- @return nil
function utils.minimize(target_client)
	target_client.minimized = true
end

--- @param target_client: awful.client
--- @return nil
function utils.click_on_window(target_client)
	target_client:activate({ context = 'mouse_click', action = 'mouse_click' })
end

--- @param target_client: awful.client
--- @return nil
function utils.move_window(target_client)
	target_client:activate({ context = 'mouse_click', action = 'mouse_move' })
end

--- @param target_client: awful.client
--- @return nil
function utils.resize_window(target_client)
	target_client:activate({ context = 'mouse_click', action = 'mouse_resize' })
end

--- @param selection boolean
--- @param window_id integer
--- @return fun(): nil
function utils.screenshot(selection, window_id)
	assert(
		type(selection) == 'boolean',
		'selection not valid for utils.screenshot'
	)

	if window_id ~= nil then
		assert(
			type(window_id) == 'number',
			'pid not valid for utils.screenshot'
		)
	end

	return function()
		local notification_app_name = 'screenshot'
		local filename = os.date('%Y.%m.%d-%H.%M.%S') .. '.webp'
		local filepath = utils.expand_path('~/Pictures/screenshots') .. '/' .. filename
		local cmd = 'maim --hidecursor --quality 10 '

		if window_id ~= nil then
			cmd = cmd .. '--window ' .. tostring(window_id) .. ' '
		end

		if selection then
			cmd = cmd .. '--bordersize 5 --select ' .. filepath

			local capture_notification = naughty.notification({
				title = 'screenshot',
				message = 'select area to capture',
				timeout = -1,
				app_name = notification_app_name
			})

			awful.spawn.easy_async_with_shell(cmd, function(_stdout, _stderr, _exitreason, exitcode)
				naughty.destroy(capture_notification)

				if (exitcode ~= 0) then
					return
				end

				naughty.notification({
					title = 'screenshot',
					message = 'selection captured',
					app_name = 'screenshot'
				})
			end)

			return
		end

		cmd = cmd .. filepath
		awful.spawn.easy_async_with_shell(cmd, function(_stdout, _stderr, _exitreason, exitcode)
			if (exitcode ~= 0) then
				return
			end

			naughty.notification({
				title = 'screenshot',
				message = 'screenshot taken',
				app_name = 'screenshot'
			})
		end)
	end
end

--- @param target_client awful.client
--- @return fun(): nil | nil
function utils.client_screenshot(target_client)
	local window_id = target_client.window

	if window_id == nil then
		return function()
			naughty.notification({
				title = 'screenshot',
				message = 'could not determine process id for window'
			})
		end
	end

	local take_screenshot = utils.screenshot(false, window_id)
	take_screenshot()
end

return utils
