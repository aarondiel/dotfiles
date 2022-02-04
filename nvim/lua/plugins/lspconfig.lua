local utils = require('utils')
local capabilities = vim.lsp.protocol.make_client_capabilities()

local function on_attach(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	vim.cmd([[
		augroup hover_diagnostic
			autocmd!
			autocmd CursorHold * lua vim.diagnostic.open_float({ scope='cursor' })
		augroup end
	]])

	local buffer_mappings = {
		{ 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', {} },
		{ 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', {} },
		{ 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {} },
		{ 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', {} },
		{ 'n', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', {} },
		{ 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>', {} },
		{ 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>', {} },
		{ 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>', {} },
		{ 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<cr>', {} },
		{ 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', {} },
		{ 'n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>', {} },
		{ 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', {} },
		{ 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>', {} },
		{ 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', {} }
	}

	if client.resolved_capabilities.document_formatting then
		table.insert(buffer_mappings, { 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<cr>', {} })
	elseif client.resolved_capabilities.document_range_formatting then
		table.insert(buffer_mappings, { 'n', '<leader>f', '<cmd>lua vim.lsp.buf.range_formatting()<cr>', {} })
	end

	for _, mapping in pairs(buffer_mappings) do
		local config = { noremap = true, silent = true }

		local mode = mapping[1]
		local left = mapping[2]
		local right = mapping[3]
		local options = mapping[4]

		if options then
			config = vim.tbl_extend('force', config, options)
		end

		vim.api.nvim_buf_set_keymap(bufnr, mode, left, right, config)
	end
end

utils.import('cmp', function (cmp)
	cmp.setup({
		snippet = {
			expand = function (args)
				vim.fn['vsnip#anonymous'](args.body)
			end
		},

		mapping = {
			[ '<tab>' ] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
			[ '<s-tab>' ] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
			[ '<c-d>' ] = cmp.mapping.scroll_docs(-4),
			[ '<c-f>' ] = cmp.mapping.scroll_docs(4),
			[ '<c-space>' ] = cmp.mapping.complete(),
			[ '<c-e>' ] = cmp.mapping.close(),
			[ '<cr>' ] = cmp.mapping.confirm({ select = true })
		},

		sources = {
			{ name = 'nvim_lsp' },
			{ name = 'nvim_lua' },
			{ name = 'vsnip' },
			{ name = 'path' },
			{ name = 'calc' },
			{ name = 'buffer' }
		}
	})

	cmp.setup.cmdline('/', {
		sources = { { name = 'buffer' } }
	})

	cmp.setup.cmdline(':', {
		sources = cmp.config.sources(
			{ { name = 'path' } },
			{ { name = 'cmdline' } }
		)
	})

	capabilities = utils.import('cmp_nvim_lsp', function (cmp_nvim_lsp)
		return cmp_nvim_lsp.update_capabilities(capabilities)
	end)
end)

utils.import('nvim-lsp-installer', function (lspinstaller)
	lspinstaller.on_server_ready(function(server)
		local server_options = {
			['sumneko_lua'] = {
				Lua = {
					runtime = {
						version = 'LuaJIT',
						path = vim.split(package.path, ';')
					},

					diagnostics = { globals = { "vim" } },

					workspace = {
						library = {
							[vim.fn.expand('$VIMRUNTIME/lua')] = true,
							[vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
							[vim.fn.stdpath('config') .. '/lua'] = true
						},
					},

					telemetry = { enable = false },

					hint = { enable = true }
				}
			},

			['jsonls'] = {
				json = {
					schemas = {
						{
							description = 'npm',
							fileMatch = { 'package.json' },
							url = 'https://json.schemastore.org/package.json'
						}
					}
				}
			}
		}

		local config = {
			on_attach = on_attach,
			capabilities = capabilities,
			settings = server_options[server.name] or {}
		}

		vim.g.server_settings = config

		server:setup(config)
	end)
end)

local lspSymbols = {
	{ name = 'DiagnosticsSignError', text = '' },
	{ name = 'DiagnosticsSignWarning', text = '' },
	{ name = 'DiagnosticsSignInformation', text = '' },
	{ name = 'DiagnosticsSignHint', text = '' }
}

for _, symbol in pairs(lspSymbols) do
	vim.fn.sign_define(
		symbol.name,
		{ texthl = symbol.name, text = symbol.text, numhl = '' }
	)
end

vim.diagnostic.config({
	virtual_text = false,
	signs = { active = lspSymbols },
	underline = true,
	float = {
		focusable = false,
		style = 'minimal',
		border = 'rounded',
		source = 'always',
		header = '',
		prefix = ''
	}
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = 'rounded'
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = 'rounded'
})
