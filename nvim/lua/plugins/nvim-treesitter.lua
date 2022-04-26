local utils = require("utils")
local ts_config = utils.import("nvim-treesitter.configs")

if ts_config == nil then
 return
end

ts_config.setup({
	ensure_installed = 'all',
	highlight = {
		enable = true,
		use_languagetree = true
	},

	indent = { enable = true },
	rainbow = { enable = true }
})
