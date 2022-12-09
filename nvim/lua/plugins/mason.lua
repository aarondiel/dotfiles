local utils = require("utils")
local mason = utils.import("mason")
local mason_lspconfig = utils.import("mason-lspconfig")
assert(mason ~= nil, "could not import mason")
assert(mason_lspconfig ~= nil, "could not import mason-lspconfig")

mason.setup({
	ui = {
		border = "rounded",
		keymaps = { uninstall_package = "D" }
	}
})

mason_lspconfig.setup({
	automatic_installation = true
})
