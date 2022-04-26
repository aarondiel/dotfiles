vim.cmd('colorscheme faber')
vim.cmd('autocmd TextYankPost * silent! lua vim.highlight.on_yank({ timeout = 400 })')
vim.cmd('autocmd FileType text setlocal spell spelllang=en')
vim.opt.termguicolors = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.wrap = false
vim.opt.hidden = true

vim.opt.foldenable = false
vim.opt.foldmethod = 'indent'

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undodir = vim.fn.expand('~/.vim/undodir')

vim.opt.shortmess:append({ c = true })
vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 100
