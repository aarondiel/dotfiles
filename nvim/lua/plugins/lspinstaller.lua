local utils = require("utils")
local lspinstaller = utils.import("nvim-lsp-installer")
assert(lspinstaller ~= nil, "could not import nvim-lsp-installer")

lspinstaller.setup({
	ensure_installed = {},
	automatic_installation = true,
	ui = {
		border = "rounded",
		icons = {
			server_installed = "✓",
			server_pending = "➜",
			server_uninstalled = "✗"
		},

		keymaps = {
			uninstall_server = "D"
		}
	}
})
