local utils = {}

function utils.import(package_name, callback, fallback)
	local available, package = pcall(require, package_name)

	if available then
		if callback ~= nil then
			return callback(package)
		end

		return package
	end

	if fallback ~= nil then
		return fallback()
	end

	return nil
end

function utils.unpack(array)
	local value = table.remove(array)

	if #array == 0 then
		return value
	end

	return value, unpack(array)
end

function utils.partial(func, ...)
	local args = { ... }

	return function (...)
		func(utils.unpack(args), ...)
	end
end

function utils.starts_with(target_string, start_string)
	return string.sub(
		target_string,
		1,
		string.len(start_string)
	) == start_string
end

function utils.keymap(mode, left, right, opts)
	local options = utils.combine(
		{ silent = true, noremap = true },
		opts or {}
	)

	vim.keymap.set(mode, left, right, options)
end

function utils.keymaps(mappings)
	for _, mapping in ipairs(mappings) do
		local mode = mapping[1]
		local left = mapping[2]
		local right = mapping[3]
		local opts = mapping[4]

		utils.keymap(mode, left, right, opts)
	end
end

function utils.map(list, func)
	local result = {}

	for i, element in ipairs(list) do
		result[i] = func(element)
	end

	return result
end

function utils.filter(list, func)
	local result = {}

	for _, element in ipairs(list) do
		if func(list) == true then
			table.insert(result, element)
		end
	end

	return result
end

function utils.any(list)
	for _, element in ipairs(list) do
		if element == true then
			return true
		end
	end

	return false
end

function utils.combine(...)
	local result = {}

	for _, current_table in pairs({ ... }) do
		for index, element in pairs(current_table) do
			result[index] = element
		end
	end

	return result
end

function utils.create_augroup(name)
	return vim.api.nvim_create_augroup(
		name,
		{ clear = true }
	)
end

return utils
