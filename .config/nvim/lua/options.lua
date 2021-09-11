vim.cmd('colorscheme faber')
vim.cmd('autocmd TextYankPost * silent! lua vim.highlight.on_yank({ timeout = 400 })')
vim.opt.termguicolors = false

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
vim.opt.signcolumn = 'number'

vim.g.nvim_tree_auto_close = 1
vim.g.nvim_quit_on_open = 1
vim.g.nvim_tree_highlight_opened_files = 1
vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_lsp_diagnostics = 1
vim.g.nvim_tree_update_cwd = 1
vim.g.nvim_tree_disable_default_keybindings = 1

local tree_cb = require('nvim-tree.config').nvim_tree_callback
vim.g.nvim_tree_bindings = {
	{ key = { '<cr>', 'l' }, cb = tree_cb('edit') },
	{ key = 'cd', cb = tree_cb('cd') },
	{ key = '<c-v>', cb = tree_cb('vsplit') },
	{ key = '<c-x>', cb = tree_cb('split') },
	{ key = '<c-t>', cb = tree_cb('tabnew') },
	{ key = '<', cb = tree_cb('prev_sibling') },
	{ key = '>', cb = tree_cb('next_sibling') },
	{ key = 'P', cb = tree_cb('parent_node') },
	{ key = '<bs>', cb = tree_cb('close_node') },
	{ key = '<s-cr>', cb = tree_cb('close_node') },
	{ key = '<tab>', cb = tree_cb('preview') },
	{ key = 'K', cb = tree_cb('first_sibling') },
	{ key = 'J', cb = tree_cb('last_sibling') },
	{ key = 'I', cb = tree_cb('toggle_ignored') },
	{ key = 'H', cb = tree_cb('toggle_dotfiles') },
	{ key = 'R', cb = tree_cb('refresh') },
	{ key = 'a', cb = tree_cb('create') },
	{ key = 'd', cb = tree_cb('remove') },
	{ key = 'r', cb = tree_cb('rename') },
	{ key = '<c-r>', cb = tree_cb('full_rename') },
	{ key = 'x', cb = tree_cb('cut') },
	{ key = 'yy', cb = tree_cb('copy') },
	{ key = 'p', cb = tree_cb('paste') },
	{ key = 'y', cb = tree_cb('copy_name') },
	{ key = 'Y', cb = tree_cb('copy_path') },
	{ key = 'gy', cb = tree_cb('copy_absolute_path') },
	{ key = '[c', cb = tree_cb('prev_git_item') },
	{ key = ']c', cb = tree_cb('next_git_item') },
	{ key = '-', cb = tree_cb('dir_up') },
	{ key = 's', cb = tree_cb('system_open') },
	{ key = 'q', cb = tree_cb('close') },
	{ key = 'g?', cb = tree_cb('toggle_help') }
}

vim.cmd('autocmd BufEnter * if (isdirectory(expand("%"))) | execute("NvimTreeFocus") | endif')
