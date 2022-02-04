local utils = {}
local awful = require('awful')
local gears = require('gears')

-- path: string
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

function utils.open_terminal()
	awful.spawn('kitty -1')
end

function utils.open_rofi()
	awful.spawn('rofi -show run')
end

-- direction: 'left' | 'up' | 'right' | 'down'
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

-- direction: 'left' | 'up' | 'right' | 'down'
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

-- direction: 1 | -1
function utils.cycle_window(direction)
	assert(
		direction == 1 or direction == -1,
		'unsupported direction for cycle_window'
	)

	return function()
		awful.client.focus.byidx(direction)
	end
end

-- direction: 'left' | 'up' | 'right' | 'down'
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

-- direction: 'left' | 'up' | 'right' | 'down'
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

-- direction: 1 | -1
function utils.cycle_layouts(direction)
	assert(
		direction == 1 or direction == -1,
		'unsupported direction for cycle_layouts'
	)

	return function()
		awful.layout.inc(direction)
	end
end

-- step: int
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

-- step: int
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

-- taget_tag: awful.tag
function utils.switch_to_tag(target_tag)
	return function()
		target_tag:view_only()
	end
end

-- index: int
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

-- index: int
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

-- taget_client: awful.client
function utils.toggle_fullscreen(target_client)
	target_client.fullscreen = not target_client.fullscreen
	target_client:raise()
end

-- target_client: awful.client
function utils.toggle_maximized(target_client)
	target_client.maximized = not target_client.maximized
	target_client:raise()
end

-- taget_client: awful.client
function utils.close_window(target_client)
	target_client:kill()
end

-- target_client: awful.client
function utils.move_to_master(target_client)
	target_client:swap(awful.client.getmaster())
end

-- target_client: awful.client
function utils.keep_window_on_top(target_client)
	target_client.ontop = not target_client.ontop
	target_client.raise()
end

-- target_client: awful.client
function utils.minimize(target_client)
	target_client.minimized = true
end

-- target_client: awful.client
function utils.click_on_window(target_client)
	target_client:activate({ context = 'mouse_click', action = 'mouse_click' })
end

-- target_client: awful.client
function utils.move_window(target_client)
	target_client:activate({ context = 'mouse_click', action = 'mouse_move' })
end

-- target_client: awful.client
function utils.resize_window(target_client)
	target_client:activate({ context = 'mouse_click', action = 'mouse_resize' })
end

return utils
