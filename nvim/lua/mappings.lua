local utils = require("utils")
local reindent_pasted_text = "'[=']"

utils.keymaps({
	{ "n", "<leader>h", "<cmd>wincmd h<cr>" },
	{ "n", "<leader>l", "<cmd>wincmd l<cr>" },
	{ "n", "<leader>j", "<cmd>wincmd j<cr>" },
	{ "n", "<leader>k", "<cmd>wincmd k<cr>" },

	{ "n", "Y", "y$" },
	{ "n", "<leader>m", "<cmd>messages<cr>" },
	{ "v", "<leader>y", "\"+y" },
	{ "n", "<leader>i", reindent_pasted_text },
	{ "n", "<leader>p", "\"+p" .. reindent_pasted_text },
	{ { "n", "v" }, "p", "p" .. reindent_pasted_text },

	{ "n", "<esc>", "<cmd>nohlsearch<cr>" },

	{ "n", "<leader>tt", "<ctrl-w>T" }
})
