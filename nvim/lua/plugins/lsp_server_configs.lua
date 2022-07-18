local utils = require("utils")
local configs = {}

local function is_vim_lua()
	local file_path = vim.fn.expand('%:p')
	local runtime_paths = vim.api.nvim_list_runtime_paths()

	for _, runtime_path in ipairs(runtime_paths) do
		if utils.starts_with(file_path, runtime_path) then
			return true
		end
	end

	return false
end

configs["sumneko_lua"] = function()
	local globals = {}
	local library = {}

	if is_vim_lua() then
		globals = { "vim" }
		library = {
			[ vim.fn.expand("$VIMRUNTIME/lua") ] = true,
			[ vim.fn.expand("$VIMRUNTIME/lua/vim/lsp") ] = true,
			[ vim.fn.stdpath("config") .. "/lua" ] = true
		}
	end

	return {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = vim.split(package.path, ";")
			},

			diagnostics = { globals = globals },
			workspace = { library = library },
			telemetry = { enable = false },
			hint = { enable = true }
		}
	}
end

return configs
