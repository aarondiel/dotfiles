local utils = require("utils")

local function highlight_yanked_text()
	local group = utils.create_augroup("HighlightYankedText")

	vim.api.nvim_create_autocmd("TextYankPost", {
		desc = "highlight text on yank",
		group = group,
		callback = function()
			vim.highlight.on_yank({ timeout = 400 })
		end
	})
end

highlight_yanked_text()
