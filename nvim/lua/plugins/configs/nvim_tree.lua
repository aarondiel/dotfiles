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

local function on_attach(bufnr)
	local api = require('nvim-tree.api')

	local function opts(desc)
		return {
			desc = 'nvim-tree: ' .. desc,
			buffer = bufnr,
			noremap = true,
			silent = true,
			nowait = true
		}
	end

	api.config.mappings.default_on_attach(bufnr)

	utils.keymaps({
		{ 'n', '<cr>', api.node.open.replace_tree_buffer, opts('Open: In Place') },
		{ 'n', 'l', api.node.open.replace_tree_buffer, opts('Open: In Place') }
	})
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

nvim_tree.setup({
	on_attach = on_attach,
	view = {
		number = true,
		relativenumber = true
	},

	renderer = {
		highlight_opened_files = "name",
		icons = {
			show = {
				file = true,
				folder = true,
				folder_arrow = true,
				git = false,
			},

			glyphs = {
				default = "󰈚",
				symlink = "",
				folder = {
					default = "",
					empty = "",
					empty_open = "",
					open = "",
					symlink = "",
					symlink_open = "",
					arrow_open = "",
					arrow_closed = "",
				},

				git = {
					unstaged = "✗",
					staged = "✓",
					unmerged = "",
					renamed = "➜",
					untracked = "★",
					deleted = "",
					ignored = "◌",
				}
			}
		}
	}
})

utils.keymaps({
	{ "n", "<leader>e", open_nvim_tree },
	{ "n", "<leader>sv", split_vertically },
	{ "n", "<leader>sh", split_horizontally }
})
