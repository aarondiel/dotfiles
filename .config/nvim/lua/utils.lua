local M = {}

M.import = function(package_name, callback, fallback)
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

return M
