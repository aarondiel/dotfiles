local utils = require("utils")
local treesitter_config = utils.import("nvim-treesitter.configs")
assert(treesitter_config ~= nil, "could not import treesitter")

treesitter_config.setup({
	ensure_installed = "all",
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false
	},

	indent = {
		enable = true
	},

	matchup = {
		enable = true
	}
})

vim.opt.foldexpr="nvim_treesitter#foldexpr()"

utils.keymap({ "n", "<leader>g", "<cmd>TSHighlightCapturesUnderCursor<cr>" })
