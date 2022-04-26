local open_nvim_tree = 'lua require("nvim-tree").open_replacing_current_buffer()'

--- @class Map_Options
--- @field nowait boolean
--- @field silent boolean
--- @field script boolean
--- @field expr boolean
--- @field unique boolean
--- @field noremap boolean

--- @param mode 'n' | 'i' | 'v' | 'x' | 'nvo' | 's' | 'o' | 'ic' | 'l' | 'c' | 't'
--- @param left string
--- @param right string
--- @param options? Map_Options
local function map(mode, left, right, options)
	local config = { noremap = true, silent = true }

	if options == nil then
		options = {}
	end

	if options then
		config = vim.tbl_extend('force', config, options)
	end

	vim.api.nvim_set_keymap(mode, left, right, options)
end

vim.g.mapleader = " "
map("n", "Y", "y$")

map("v", "<leader>y", "\"+y")

map("n", "<leader>e", "<cmd> " .. open_nvim_tree .. "<cr>")
map("n", "<leader>sv", "<cmd>vs <bar> wincmd l <bar> " .. open_nvim_tree .. "<cr>")
map("n", "<leader>sh", "<cmd>sp <bar> wincmd j <bar> " .. open_nvim_tree .. "<cr>")

map("n", "<leader>h", "<cmd>wincmd h<cr>")
map("n", "<leader>j", "<cmd>wincmd j<cr>")
map("n", "<leader>k", "<cmd>wincmd k<cr>")
map("n", "<leader>l", "<cmd>wincmd l<cr>")

map("n", "<esc>", "<cmd>noh<cr>")

map("n", "<leader>fd", "<cmd>Telescope live_grep<cr>")
map("n", "<leader>g", "<cmd>TSHighlightCapturesUnderCursor<cr>")
