local mappings = {}
local modkey = 'Mod4'
local alt = 'Mod1'
local alt_gr = 'Mod1'
local control = 'Control'
local shift = 'Shift'

--- @module 'awful.init'
local awful = require('awful')
--- @module 'gears.init'
local gears = require('gears')
local utils = require('utils')

--- @class Keyboard_Mapping
--- @field combination string[]
--- @field callback fun(): nil
--- @field description string
--- @field group string

--- @class Mouse_Mapping
--- @field combination string[]
--- @field callback fun(): nil
--- @field description string
--- @field group string

--- @param mapping Keyboard_Mapping
--- @return awful.key
local function mapping_to_key(mapping)
	assert(
		type(mapping) == 'table' and #mapping == 4,
		'mapping not valid for mapping_to_key'
	)

	local combination = mapping[1]
	for key, value in pairs(combination) do
		if type(key) == 'number' and type(value) == 'string' then
			goto continue
		end

		table.remove(combination, key)

		::continue::
	end

	assert(
		type(combination) == 'table' and #combination >= 1,
		'combination not valid for mapping_to_key'
	)

	local key = table.remove(combination)
	local modifiers = combination

	local callback = mapping[2]
	assert(type(callback) == 'function', 'callback not valid for mapping_to_key')

	local description = mapping[3]
	assert(type(description) == 'string', 'description not valid for mapping_to_key')

	local group = mapping[4]
	assert(type(group) == 'string', 'group not valid for mapping_to_key')

	return awful.key(modifiers, key, callback, {
		description = description,
		group = group
	})
end

--- @param mapping Mouse_Mapping
--- @return awful.button
local function mapping_to_button(mapping)
	assert(
		type(mapping) == 'table' and #mapping == 4,
		'mapping not valid for mapping_to_button: ' .. tostring(mapping)
	)

	local combination = mapping[1]
	assert(
		type(combination) == 'table' and #combination >= 1,
		'combination not valid for mapping_to_button'
	)

	local button = table.remove(combination)
	assert(type(button) == 'number' and button >= 1 and button <= 5)
	button = math.floor(button)

	for key, value in pairs(combination) do
		if type(key) == 'number' and type(value) == 'string' then
			goto continue
		end

		table.remove(combination, key)

		::continue::
	end

	local modifiers = combination

	local callback = mapping[2]
	assert(type(callback) == 'function', 'callback not valid for mapping_to_key')

	local description = mapping[3]
	assert(type(description) == 'string', 'description not valid for mapping_to_key')

	local group = mapping[4]
	assert(type(group) == 'string', 'group not valid for mapping_to_key')

	return awful.button(modifiers, button, callback, {
		description = description,
		group = group
	})
end

local global_keys = {
	{ { modkey, shift, 'r' }, awesome.restart, 'reload awesome', 'general' },

	{ { modkey, 'Return' }, utils.open_terminal, 'open terminal', 'general' },
	{ { modkey, 'd' }, utils.open_rofi, 'open rofi', 'general' },

	{ { modkey, 'Left' }, awful.tag.viewprev, 'switch to tag below', 'general' },
	{ { modkey, 'Right' }, awful.tag.viewnext, 'switch to tag above', 'general' },

	{ { modkey, 'l' }, utils.focus_window('right'), 'focus window to the right', 'general' },
	{ { modkey, 'k' }, utils.focus_window('up'), 'focus window above', 'general' },
	{ { modkey, 'h' }, utils.focus_window('left'), 'focus window to the left', 'general' },
	{ { modkey, 'j' }, utils.focus_window('down'), 'focus window below', 'general' },

	{ { modkey, shift, 'l' }, utils.swap_window('right'), 'swap focused window to the left', 'general' },
	{ { modkey, shift, 'k' }, utils.swap_window('up'), 'swap focused window with window above', 'general' },
	{ { modkey, shift, 'h' }, utils.swap_window('left'), 'swap focused window to the right', 'general' },
	{ { modkey, shift, 'j' }, utils.swap_window('down'), 'swap focused window with window below', 'general' },

	{ { modkey, control, 'l' }, utils.focus_screen('right'), 'focus screen to the right', 'general' },
	{ { modkey, control, 'k' }, utils.focus_screen('up'), 'focus screen above', 'general' },
	{ { modkey, control, 'h' }, utils.focus_screen('left'), 'focus screen to the left', 'general' },
	{ { modkey, control, 'j' }, utils.focus_screen('down'), 'focus screen below', 'general' },

	{ { modkey, control, 'l' }, utils.move_to_screen('right'), 'focus screen to the right', 'general' },
	{ { modkey, control, 'k' }, utils.move_to_screen('up'), 'focus screen above', 'general' },
	{ { modkey, control, 'h' }, utils.move_to_screen('left'), 'focus screen to the left', 'general' },
	{ { modkey, control, 'j' }, utils.move_to_screen('down'), 'focus screen below', 'general' },

	{ { modkey, 'Tab' }, utils.cycle_window(1), 'cycle to the next window', 'general' },
	{ { modkey, shift, 'Tab' }, utils.cycle_window(-1), 'cycle to the previous window', 'general' },

	{ { 'Print' }, utils.screenshot(false), 'take screenshot', 'screenshot' },
	{ { shift, 'Print' }, utils.screenshot(true), 'capture selection', 'screenshot' },

	{ { modkey, 'n' }, utils.restore_minimized, 'restore minimized windows', 'general' },

	{ { modkey, 'space' }, utils.cycle_layouts(1), 'cycle layouts', 'general' },
	{ { modkey, shift, 'space' }, utils.cycle_layouts(-1), 'cycle layouts backwards', 'general' },

	{ { modkey, '=' }, utils.change_gap(5), 'increase gap', 'general' },
	{ { modkey, shift, '=' }, utils.change_gap(-5), 'decrease gap', 'general' },

	{ { 'XF86AudioLowerVolume' }, utils.change_volume(-5), 'lower volume', 'audio' },
	{ { 'XF86AudioRaiseVolume' }, utils.change_volume(5), 'lower volume', 'audio' },
	{ { 'XF86AudioMute' }, utils.change_volume(0), 'mute audio', 'audio' },
	{ { 'XF86MonBrightnessDown' }, utils.change_brightness(-5), 'decrease monitor brightness', 'audio' },
	{ { 'XF86MonBrightnessUp' }, utils.change_brightness(5), 'increase monitor brightness', 'audio' }
}

for i = 1, 9 do
	table.insert(global_keys, {
		{ modkey, tostring(i) },
		utils.switch_to_tag_index(i),
		'switch to tag ' .. tostring(i),
		'general'
	})

	table.insert(global_keys, {
		{ modkey, shift, tostring(i) },
		utils.move_to_tag(i),
		'move focused window to tag ' .. tostring(i),
		'general'
	})
end

local client_keys = {
	{ { modkey, 'f' }, utils.toggle_fullscreen, 'toggle fullscreen on focused window', 'general' },
	{ { modkey, shift, 'f' }, utils.toggle_maximized, 'toggle maximization on focused window', 'general' },
	{ { modkey, shift, 'c' }, utils.close_window, 'close focused window', 'general' },
	{ { modkey, alt, 'space' }, awful.client.floating.toggle, 'change focused window\'s layout to floating', 'general' },
	{ { modkey, control, 'Return' }, utils.move_to_master, 'swap focused window with master window', 'general' },
	{ { modkey, 't' }, utils.keep_window_on_top, 'keep window on top', 'general' },
	{ { modkey, shift, 'n' }, utils.minimize, 'minimize focused window', 'general' },
	{ { modkey, 'Print' }, utils.client_screenshot, 'take screenshot of focused window', 'screenshot' }
}

local global_buttons = {}

local client_buttons = {
	{ { 1 }, utils.click_on_window, 'click', 'general' },
	{ { modkey, 1 }, utils.move_window, 'move window', 'general' },
	{ { modkey, 3 }, utils.resize_window, 'resize window', 'general' }
}

mappings.global_keys = gears.table.map(mapping_to_key, global_keys)
mappings.client_keys = gears.table.map(mapping_to_key, client_keys)

mappings.global_butons = gears.table.map(mapping_to_button, global_buttons)
mappings.client_butons = gears.table.map(mapping_to_button, client_buttons)

root.keys(mappings.global_keys)
root.buttons(mappings.buttons)

return mappings
