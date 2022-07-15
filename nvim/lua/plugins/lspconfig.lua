local utils = require("utils")
local lspconfig = utils.import("lspconfig")
local lsp_server_configs = utils.import("plugins.lsp_server_configs")
utils.import("plugins.cmp")

assert(lspconfig ~= nil, "could not import lspconfig")
assert(lsp_server_configs ~= nil, "could not import lsp_server_configs")

local function on_attach(_, buffer_number)
	vim.opt.omnifunc = "v:lua.vim.lsp.omnifunc"

	local buffer = { buffer = buffer_number }
	local mappings = {
		{ "n", "<leader>d", vim.diagnostic.open_float, buffer },
		{ "n", "[d", vim.diagnostic.goto_prev, buffer },
		{ "n", "]d", vim.diagnostic.goto_next, buffer },
		{ "n", "<leader>q", vim.diagnostic.setloclist, buffer },

		{ "n", "gD", vim.lsp.buf.declaration, buffer },
		{ "n", "gd", vim.lsp.buf.definition, buffer },
		{ "n", "K", vim.lsp.buf.hover, buffer },
		{ "n", "gi", vim.lsp.buf.implementation, buffer },
		{ "n", "<c-k>", vim.lsp.buf.signature_help, buffer },
		{ "n", "<leader>D", vim.lsp.buf.type_definition, buffer },
		{ "n", "<leader>rn", vim.lsp.buf.rename, buffer },
		{ "n", "<leader>ca", vim.lsp.buf.code_action, buffer },
		{ "n", "gr", vim.lsp.buf.references, buffer },
		{ "n", "<leader>f", vim.lsp.buf.formatting, buffer }
	}

	utils.map(mappings, utils.keymap)
end

local function generate_capabilities()
	return utils.import("cmp_nvim_lsp", function(cmp_nvim_lsp)
		local original_capabilities = vim.lsp.protocol.make_client_capabilities()

		return cmp_nvim_lsp.update_capabilities(original_capabilities)
	end)
end

local function suppress_lsp_error_messages()
	vim.notify = function(msg, log_level)
		if msg:match "exit code" then
			return
		end
		if log_level == vim.log.levels.ERROR then
			vim.api.nvim_err_writeln(msg)
		else
			vim.api.nvim_echo({ { msg } }, true, {})
		end
	end
end

local function setup_lsp_signs()
	local signs = {
		Error = "",
		Info = "",
		Hint = "",
		Warn = ""
	}

	for sign_name, sign in pairs(signs) do
		local highlight = "DiagnosticSign" .. sign_name

		vim.fn.sign_define(highlight, {
			text = sign,
			numhl = highlight,
			texthl = highlight
		})
	end
end

local function add_hover_info()
	local group = utils.create_augroup("lsp_hover")

	vim.api.nvim_create_autocmd("CursorHold", {
		desc = "show lsp info on hover",
		group = group,
		callback = vim.diagnostic.open_float
	})
end

local function setup_lsp_config()
	vim.diagnostic.config({
		virtual_text = false,
		severity_sort = true,
		float = { scope = "cursor", focusable = false }
	})

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
		vim.lsp.handlers.hover,
		{ border = "single" }
	)

	local signature_help_options = {
		border = "single",
		focusable = false,
		relative = "cursor",
	}

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
		vim.lsp.handlers.signature_help,
		signature_help_options
	)

	add_hover_info()
	suppress_lsp_error_messages()
	setup_lsp_signs()
end

local function load_lsp_configs()
	local capabilities = generate_capabilities()

	for server_name, server_config in pairs(lsp_server_configs) do
		local config = {}

		if type(server_config) == "table" then
			config = server_config
		elseif type(server_config) == "function" then
			config = server_config()
		else
			error("server_config is neither a table nor a function")
		end

		lspconfig[server_name].setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = config
		})
	end
end

setup_lsp_config()
load_lsp_configs()
