local gears = require('gears')
local beautiful = require('beautiful')
local utils = require('utils')

math.randomseed(os.time())

---@param str string
---@return string
local function escape_string(str)
	local result = '\''

	for i = 1, #str do
		local c = str:sub(i, i)

		if c == '\'' then
			result = result .. '\\' .. c
		else
			result = result .. c
		end
	end

	result = result .. '\''

	return result
end

---@param path string
---@param recursive boolean
---@return string[]
local function list_files(path, recursive)
	if gears.filesystem.file_readable(path) then
		return { path }
	end

	if not gears.filesystem.dir_readable(path) then
		return {}
	end

	local output = io.popen("ls -A " .. escape_string(path))
	local result = {}

	if output == nil then
		return {}
	end

	for file in output:lines() do
		file = path .. "/" .. file

		if gears.filesystem.file_readable(file) then
			table.insert(result, file)
		elseif gears.filesystem.dir_readable(file) and recursive then
			result = gears.table.join(result, list_files(file, recursive))
		end
	end

	return result
end

---@generic T
---@param target T[]
---@return T
local function random_choice(target)
	local index = math.random() * (#target - 1) + 1
	index = math.floor(index)

	return target[index]
end

screen.connect_signal('request::wallpaper', function(target_screen)
	local files = list_files(beautiful.wallpaper, true)
	local file = random_choice(files)

	gears.wallpaper.maximized(file, target_screen)
end)

gears.timer({
	timeout = 10 * 60,
	autostart = true,
	callback = utils.change_wallpapers
})
