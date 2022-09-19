local utils = require("utils")
local mason = utils.import("mason")
assert(mason ~= nil, "could not import mason")

local function update_with_packer()
	local group = utils.create_augroup("UpdateLspWithPacker")

	vim.api.nvim_create_autocmd("User", {
		desc = "update mason with packer",
		pattern = "PackerComplete",
		group = group,
		command = "MasonToolsUpdate"
	})
end

mason.setup({
	ui = {
		border = "rounded",
		keymaps = { uninstall_package = "D" }
	}
})

update_with_packer()
