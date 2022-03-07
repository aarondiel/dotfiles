local utils = {}

--- @param target_string string
--- @param start_string string
--- @return boolean
function utils.starts_with(target_string, start_string)
	return string.sub(
		target_string,
		1,
		string.len(start_string)
	) == start_string
end

--- @param package_name string
--- @param callback? fun(): nil
--- @param fallback? fun(): nil
--- @return any?
function utils.import(package_name, callback, fallback)
	local available, package = pcall(require, package_name)

	if available then
		if callback then
			return callback(package)
		end

		return package
	end

	if fallback then
		return fallback()
	end

	return nil
end

return utils
