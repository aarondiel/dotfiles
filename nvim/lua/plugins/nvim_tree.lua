local utils = require("utils")
local nvim_tree = utils.import("nvim-tree")
assert(nvim_tree ~= nil, "could not import nvim-tree")

local function open_nvim_tree()
	nvim_tree.open_replacing_current_buffer()
end

local function split_vertically()
	vim.cmd("vsplit | wincmd l")
	open_nvim_tree()
end

local function split_horizontally()
	vim.cmd("split | wincmd j")
	open_nvim_tree()
end

nvim_tree.setup({
	view = {
		number = true,
		relativenumber = true,
		mappings = {
			custom_only = false,
			list = { { key = { "<cr>", "l" }, action = "edit_in_place" } }
		}
	},

	renderer = {
		highlight_opened_files = "name",
		icons = { show = { git = false } }
	}
})

utils.keymaps({
	{ "n", "<leader>e", open_nvim_tree },
	{ "n", "<leader>sv", split_vertically },
	{ "n", "<leader>sh", split_horizontally }
})
