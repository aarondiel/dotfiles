local function map(mode, left, right, options)
	local config = { noremap = true, silent = true }
	if options then
		config = vim.tbl_extend('force', config, options)
	end
	vim.api.nvim_set_keymap(mode, left, right, options)
end

vim.g.mapleader = ' '
map('n', 'Y', 'y$', {})

map('n', '<leader>sv', '<cmd>vs <bar> wincmd l <bar> edit .<cr>', {})
map('n', '<leader>sh', '<cmd>sp <bar> wincmd j <bar> edit .<cr>', {})

map('n', '<leader>e', '<cmd>edit .<cr>', {})
map('v', '<leader>y', '"+y', {})

map('n', '<leader>h', '<cmd>wincmd h<cr>', {})
map('n', '<leader>j', '<cmd>wincmd j<cr>', {})
map('n', '<leader>k', '<cmd>wincmd k<cr>', {})
map('n', '<leader>l', '<cmd>wincmd l<cr>', {})

map('n', '<leader>r', '<cmd>%so <bar> PackerSync<cr>', {})