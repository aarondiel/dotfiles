local utils = require("utils")
local reindent_pasted_text = "'[=']"

local mappings = {
	{ "n", "<leader>h", "<cmd>wincmd h<cr>" },
	{ "n", "<leader>l", "<cmd>wincmd l<cr>" },
	{ "n", "<leader>j", "<cmd>wincmd j<cr>" },
	{ "n", "<leader>k", "<cmd>wincmd k<cr>" },

	{ "n", "Y", "y$" },
	{ "v", "<leader>y", "\"+y" },
	{ "n", "<leader>i", reindent_pasted_text },
	{ "n", "<leader>p", "\"+p" .. reindent_pasted_text },
	{ "n", "p", "p" .. reindent_pasted_text },

	{ "n", "<esc>", "<cmd>nohlsearch<cr>" },
	{ "n", "<leader>r", "<cmd>w <bar> source %<cr>" },
}

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

utils.map(mappings, utils.keymap)
