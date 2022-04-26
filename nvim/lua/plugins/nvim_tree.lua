local utils = require("utils")
local nvim_tree = utils.import("nvim-tree")
local nvim_tree_config = utils.import("nvim-tree.config")

if nvim_tree == nil or nvim_tree_config == nil then
	return
end

vim.g.nvim_tree_highlight_opened_files = 3
vim.g.nvim_tree_group_empty = 1

local tree_cb = nvim_tree_config.nvim_tree_callback
local mappings = {
	{ key = { "<cr>", "l" }, cb = tree_cb("edit") },
	{ key = "cd", cb = tree_cb("cd") },
	{ key = "<c-v>", cb = tree_cb("vsplit") },
	{ key = "<c-x>", cb = tree_cb("split") },
	{ key = "<c-t>", cb = tree_cb("tabnew") },
	{ key = "<", cb = tree_cb("prev_sibling") },
	{ key = ">", cb = tree_cb("next_sibling") },
	{ key = "P", cb = tree_cb("parent_node") },
	{ key = "<bs>", cb = tree_cb("close_node") },
	{ key = "<s-cr>", cb = tree_cb("close_node") },
	{ key = "<tab>", cb = tree_cb("preview") },
	{ key = "K", cb = tree_cb("first_sibling") },
	{ key = "J", cb = tree_cb("last_sibling") },
	{ key = "I", cb = tree_cb("toggle_ignored") },
	{ key = "H", cb = tree_cb("toggle_dotfiles") },
	{ key = "R", cb = tree_cb("refresh") },
	{ key = "a", cb = tree_cb("create") },
	{ key = "d", cb = tree_cb("remove") },
	{ key = "r", cb = tree_cb("rename") },
	{ key = "<c-r>", cb = tree_cb("full_rename") },
	{ key = "x", cb = tree_cb("cut") },
	{ key = "yy", cb = tree_cb("copy") },
	{ key = "p", cb = tree_cb("paste") },
	{ key = "y", cb = tree_cb("copy_name") },
	{ key = "Y", cb = tree_cb("copy_path") },
	{ key = "gy", cb = tree_cb("copy_absolute_path") },
	{ key = "[c", cb = tree_cb("prev_git_item") },
	{ key = "]c", cb = tree_cb("next_git_item") },
	{ key = "-", cb = tree_cb("dir_up") },
	{ key = "s", cb = tree_cb("system_open") },
	{ key = "q", cb = tree_cb("close") },
	{ key = "g?", cb = tree_cb("toggle_help") }
}

nvim_tree.setup({
	view = {
		mappings = {
			custom_only = vim.fn.empty(mappings) == 0,
			list = mappings
		}
	},

	actions = {
		open_file = {
			quit_on_open = true,
			window_picker = { enable = false }
		}
	}
})
