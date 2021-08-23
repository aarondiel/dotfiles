local function map(mode, left, right, options)
	local config = { noremap = true, silent = true }
	if options then
		config = vim.tbl_extend('force', config, options)
	end
	vim.api.nvim_set_keymap(mode, left, right, options)
end

-- packer

require('packer_init')

-- options

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.wrap = false
vim.opt.hidden = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undodir = vim.fn.expand('~/.vim/undodir')

vim.opt.shortmess:append({ c = true })
vim.opt.completeopt = 'menuone,noinsert,noselect'

-- mappings

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
