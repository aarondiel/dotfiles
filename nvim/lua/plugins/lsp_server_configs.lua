local utils = require("utils")
local configs = {}

configs["sumneko_lua"] = function()
	local file_path = vim.fn.expand('%:p')
	local globals = {}
	local library = {}

	if (utils.starts_with(file_path, vim.fn.stdpath("config"))) then
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
