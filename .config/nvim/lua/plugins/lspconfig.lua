local lspconfig_present, lspconfig = pcall(require, 'lspconfig')
local lspinstall_present, lspinstall = pcall(require, 'lspinstall')
if not (lspconfig_present or lspinstall_present) then
	return
end

local function on_attach(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

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
		{ 'n', '<space>de', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>', {} },
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

	local completion_present, completion = pcall(require, 'completion')
	if completion_present then
		local expr_option = { expr = true }

		table.insert(
			buffer_mappings,
			{ 'i', '<tab>', 'pumvisible() ? "\\<c-n>" : "\\<tab>"', expr_option}
		)
		table.insert(
			buffer_mappings,
			{ 'i', '<s-tab>', 'pumvisible() ? "\\<c-p>" : "\\<s-tab>"', expr_option}
		)

		vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
			vim.lsp.diagnostic.on_publish_diagnostics,
			{ update_in_insert = true }
		)

		completion.on_attach()
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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local function setup_servers()
	lspinstall.setup()
	local servers = lspinstall.installed_servers()

	for _, lang in pairs(servers) do
		if (lang == 'lua') then
			lspconfig[lang].setup {
				on_attach = on_attach,

				settings = {
					Lua = {
						diagnostics = {
							globals = { 'vim' }
						},
						workspace = {
							library = {
								[vim.fn.expand('$VIMRUNTIME/lua')] = true,
								[vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
							},
							maxPreload = 100000,
							preloadFileSize = 10000
						},
						telemetry = {
							enable = false
						}
					}
				}
			}
		else
			lspconfig[lang].setup {
				on_attach = on_attach,
				capabilities = capabilities
			}
		end
	end
end

setup_servers()

-- reload after :LspInstall <server>
lspinstall.post_install_hook = setup_servers

-- replace the default lsp diagnostic symbols
local lspSymbols = {
	{ 'Error', '' },
	{ 'Warning', '' },
	{ 'Information', '' },
	{ 'Hint', '' }
}

for _, symbol in pairs(lspSymbols) do
	local name = symbol[1]
	local icon = symbol[2]

	vim.fn.sign_define('LspDiagnosticsSign' .. name, { text = icon, numhl = 'LspDiagnosticsDefaul' .. name })
end

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = {
			prefix = '',
			spacing = 0
		},
		signs = true,
		underline = true
	}
)

-- suppress error messages from lang servers
vim.notify = function(msg, log_level, _)
	if msg:match('exit code') then
		return
	end

	if log_level == vim.log.levels.ERROR then
		vim.api.nvim_err_writeln(msg)
	else
		vim.api.nvim_echo({ { msg } }, true, {})
	end
end
