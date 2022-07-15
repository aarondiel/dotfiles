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

local function auto_compile_packer_config()
	local group = utils.create_augroup("AutoCompilePackerConfig")

	vim.api.nvim_create_autocmd("BufWritePost", {
		desc = "automatically compile packer config on change",
		group = group,
		pattern = vim.fn.stdpath("config") .. "/lua/plugins.lua",
		callback = function(event)
			vim.cmd("source " .. event.file)
			local packer = utils.import("packer")
			assert(packer ~= nil, "could not import packer")

			packer.sync()
		end
	})
end

highlight_yanked_text()
auto_compile_packer_config()
