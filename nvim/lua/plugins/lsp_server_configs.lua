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

configs.jdtls = {
	java = {
		home = nil,
		maxConcurrentBuilds = 1,
		autobuild = { enabled = true },
		progressReports = { enabled = true },
		trace = { server = "off" },
		typeHierarchy = { lazyLoad = false },
		contentProvider = { preferred = nil },
		eclipse = { downloadSources = false },
		foldingRange = { enabled = true },
		implementationsCodeLens = { enabled = false },
		symbols = { includeSourceMethodDeclarations = false },
		referencesCodeLens = { enabled = false },
		saveActions = { organizeImports = false },
		selectionRange = { enabled = true },
		server = { launchMode = "Hybrid" },
		settings = { url = nil },
		quickfix = { showAt = "line" },
		showBuildStatusOnStart = { enabled = "notification" },
		codeAction = { sortMembers = { avoidVolatileChanges = true } },
		imports = { gradle = { wrapper = { checksums = {} } } },
		errors = { incompleteClasspath = { severity = "warning" } },
		recommendations = { dependency = { analytics = { show = true } } },

		codeGeneration = {
			generateComments = false,
			insertionLocation = "afterCursor",
			useBlocks = false,

			hashCodeEquals = {
				useInstanceof = false,
				useJava7Objects = false,
			},

			toString = {
				codeStyle = "STRING_CONCATENATION",
				limitElements = 0,
				listArrayContents = true,
				skipNullValues = false,
				template = "${object.className} { ${member.name()}=${member.value}, ${otherMembers} }",
			}
		},

		compile = { nullAnalysis = {
			nonnull = {
				"javax.annotation.Nonnull",
				"org.eclipse.jdt.annotation.NonNull",
				"org.springframework.lang.NonNull"
			},

			nullable = {
				"javax.annotation.Nullable",
				"org.eclipse.jdt.annotation.Nullable",
				"org.springframework.lang.Nullable"
			}
		} },

		completion = {
			enabled = true,
			maxResults = 0,
			guessMethodArguments = true,
			favoriteStaticMembers = {
				"org.junit.Assert.*",
				"org.junit.Assume.*",
				"org.junit.jupiter.api.Assertions.*",
				"org.junit.jupiter.api.Assumptions.*",
				"org.junit.jupiter.api.DynamicContainer.*",
				"org.junit.jupiter.api.DynamicTest.*",
				"org.mockito.Mockito.*",
				"org.mockito.ArgumentMatchers.*",
				"org.mockito.Answers.*"
			},

			filteredTypes = {
				"java.awt.*",
				"com.sun.*",
				"sun.*",
				"jdk.*",
				"org.graalvm.*",
				"io.micrometer.shaded.*"
			},

			importOrder = {
				"#",
				"java",
				"javax",
				"org",
				"com",
				""
			}
		},

		configuration = {
			checkProjectSettingsExclusions = false,
			runtimes = {},
			updateBuildConfiguration = "interactive",
			workspaceCacheLimit = 90,

			maven = {
				globalSettings = nil,
				notCoveredPluginExecutionSeverity = "warning",
				userSettings = nil
			}
		},

		format = {
			enabled = true,
			comments = { enabled = true },
			onType = { enabled = true },
			settings = {
				profile = nil,
				url = nil
			}
		},

		import = {
			generatesMetadataFilesAtProjectRoot = false,
			exclusions = {
				"**/node_modules/**",
				"**/.metadata/**",
				"**/archetype-resources/**",
				"**/META-INF/maven/**"
			},

			gradle = {
				arguments = nil,
				enabled = true,
				home = nil,
				jvmArguments = nil,
				version = nil,
				java = { home = nil },
				offline = { enabled = false },
				user = { home = nil },
				wrapper = { enabled = true }
			},

			maven = {
				enabled = true,
				offline = { enabled = false },
			}
		},

		inlayHints = {
			enabled = "literals",
			exclusions = {}
		},

		jdt = { ls = {
			vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m -Xlog:disable",
			androidSupport = { enabled = "auto" },
			java = { home = nil },
			lombokSupport = { enabled = true },
			protobufSupport = { enabled = true }
		} },

		maven = {
			downloadSources = false,
			updateSnapshots = false,
		},

		project = {
			encoding = "ignore",
			importHint = true,
			importOnFirstTimeStartup = "automatic",
			outputPath = "",
			referencedLibraries = { "lib/**/*.jar" },
			resourceFilters = { "node_modules","\\.git" },
			sourcePaths = {}
		},

		references = {
			includeAccessors = true,
			includeDecompiledSources = true
		},

		signatureHelp = {
			description = { enabled = false },
			enabled = true
		},

		sources = { organizeImports = {
			starThreshold = 99,
			staticStarThreshold = 99
		} },

		templates = {
			fileHeader = {},
			typeComment = {}
		}
	}
}

configs.clangd = {}
configs.cssls = {}
configs.pyright = {}
configs.rust_analyzer = {}

return configs
