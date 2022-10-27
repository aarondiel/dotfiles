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

function configs.sumneko_lua()
	local globals = { "require" }
	local library = {}

	if is_vim_lua() then
		table.insert(globals, "vim")

		library[vim.fn.expand("$VIMRUNTIME/lua")] = true
		library[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
		library[vim.fn.stdpath("config") .. "/lua"] = true
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

function configs.tsserver()
	local config = {}

	config.javascript = {
		autoClosingTags = true,
		format = {
			enable = true,
			insertSpaceAfterConstructor = true,
			insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = true,
			insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = true,
			semicolons = "remove"
		},

		preferences = {
			importModuleSpecifier = "non-relative",
			quoteStyle = "double"
		}
	}

	config.typescript = {
		format = config.javascript.format,
		locale = "en",
		preferences = config.javascript.format,
		surveys = { enabled = false }
	}

	return config
end

configs.html = {
	format = { indentInnerHtml = true }
}

configs.jsonls = {
	json = {
		schemas = {
			{
				description = 'npm',
				fileMatch = { 'package.json' },
				url = 'https://json.schemastore.org/package.json'
			},
			{
				description = 'tsconfig',
				fileMatch = { 'tsconfig.json' },
				url = 'https://json.schemastore.org/tsconfig.json'
			}
		}
	}
}

configs.svelte = {
	svelte = {
		["eable-ts-plugin"] = true,
		plugin = {
			svelte = { defaultScriptLanguage = "ts" }
		}
	}
}

configs.volar = {
	volar = {
		autoCompleteRefs = true,
		codeLens = { scriptSetupTools = true }
	}
}

configs.clangd = {}
configs.cssls = {}
configs.pyright = {}
configs.rust_analyzer = {}
configs.jdtls = {}

return configs
