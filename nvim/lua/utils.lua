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

function utils.starts_with(target_string, start_string)
	return string.sub(
		target_string,
		1,
		string.len(start_string)
	) == start_string
end

function utils.keymap(keymap)
	local mode = keymap[1]
	local left = keymap[2]
	local right = keymap[3]
	local options = keymap[4]
	local default_options = {
		silent = true,
		noremap = true
	}

	if options == nil then
		options = default_options
	else
		options = vim.fn.extend(
			default_options,
			options
		)
	end

	vim.keymap.set(mode, left, right, options)
end

function utils.map(list, func)
	local result = {}

	for i, element in ipairs(list) do
		result[i] = func(element)
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
