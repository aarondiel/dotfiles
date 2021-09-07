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

vim.g.NERDTreeMapCustomOpen = 'l'
