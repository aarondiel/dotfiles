vim.g.mapleader = vim.api.nvim_replace_termcodes("<space>", true, true, true)

vim.opt.foldenable = true
vim.opt.foldmethod = "expr"
vim.opt.foldlevel = 0
vim.opt.foldlevelstart = 4
vim.opt.foldnestmax = 4

vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.breakindent = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'number'
vim.opt.cmdheight = 2
vim.opt.colorcolumn = "80"
vim.opt.scrolloff = 4

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 0

local undodir = vim.fn.expand("~/.vim/undodir")
vim.fn.mkdir(undodir, "p")
vim.opt.undodir = undodir
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

vim.opt.termguicolors = true

vim.opt.menuitems = 50
vim.opt.shortmess:append({ c = true })
vim.opt.completeopt = { "menuone", "preview", "noinsert", "noselect" }

vim.opt.bufhidden = "hide"

vim.opt.updatetime = 500
