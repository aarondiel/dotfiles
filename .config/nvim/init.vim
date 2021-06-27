let mapleader=" "

set noerrorbells
set noexpandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set nu
set nowrap
set smartcase
set noswapfile
set undodir=~/.vim/undodir
set undofile
set incsearch
set relativenumber
set encoding=UTF-8
set hidden
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c
set ignorecase
filetype plugin on

call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'morhetz/gruvbox'
Plug 'lervag/vimtex'
call plug#end()

colorscheme gruvbox
set background=dark

let g:vimtex_view_general_viewer = "evince"
let g:vimtex_compiler_latexmk = {
	\	'build_dir' : 'build',
	\	'callback' : 0,
	\	'continuous' : 1,
	\	'executable' : 'latexmk',
	\	'hooks' : [],
	\	'options' : [
	\		'-verbose',
	\		'-file-line-error',
	\		'-synctex=1',
	\		'-interaction=nonstopmode',
	\	],
	\ }
let g:build_dir = 'build'
let g:callback = 0
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDTreeMapCustomOpen = 'l'
let g:NERDCreateDefaultMappings = 0
let g:coc_global_extensions = [
	\ 'coc-clangd',
	\ 'coc-css',
	\ 'coc-eslint',
	\ 'coc-html',
	\ 'coc-json',
	\ 'coc-lua',
	\ 'coc-pairs',
	\ 'coc-python',
	\ 'coc-sql',
	\ 'coc-vetur',
	\ 'coc-vimtex'
	\ ]

nmap ++ <plug>NERDCommenterComment
nmap <silent><leader>gh :diffget //2<cr>
nmap <silent><leader>gl :diffget //3<cr>
nmap <silent><leader>gs :G<cr>
nmap <silent><Leader>e :edit .<cr>
nmap <silent><leader>h :wincmd h<cr>
nmap <silent><leader>j :wincmd j<cr>
nmap <silent><leader>k :wincmd k<cr>
nmap <silent><leader>l :wincmd l<cr>
nmap <silent><Leader>+ :vertical resize +5<cr>
nmap <silent><Leader>- :vertical resize -5<cr>
nmap <silent><Leader>sv :vs <cr> :wincmd l <bar> :edit .<cr>
nmap <silent><Leader>sh :sp <bar> :wincmd j <bar> :edit .<cr>
nmap <silent><Leader>t :tabedit <bar> :edit .<cr>
nmap <silent><leader>gd <plug>coc-definition
nmap <silent><leader>gy <plug>coc-type-definition
nmap <silent><leader>gi <plug>coc-implementation
nmap <silent><leader>gr <plug>coc-references
nmap <silent><leader>K :call <SID>show_documentation()<cr>
nmap <leader>rn <plug>(coc-rename)
nmap <silent><expr> ZZ or(expand('%:t') !~ '^NERD.*', winnr('$') == 1) ? ':wq<cr>' : ':NERDTreeClose<cr>'
nmap <silent><expr> ZQ or(expand('%:t') !~ '^NERD.*', winnr('$') == 1) ? ':q!<cr>' : ':NERDTreeClose<cr>'

tmap <Esc> <C-\><C-n>
vmap ++ <plug>NERDCommenterToggle
imap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() :
	\ getline('.')[col('.') - 2] =~ "[{\[\'\"]" ? "<cr><ESC>O<TAB>" : "<cr>"
imap <silent><expr> <C-Space> pumvisible() ? coc#refresh() : ""

function Longtab()
	setlocal tabstop=4
	setlocal softtabstop=4
	setlocal shiftwidth=4
endfunction

augroup custom
	autocmd!
	autocmd TermOpen * setlocal nonumber norelativenumber
	autocmd CursorHold * silent call CocActionAsync('highlight')
augroup END

inoremap <silent><expr> <TAB>
	\ pumvisible() ? "\<C-n>" :
	\ <SID>check_back_space() ? "\<TAB>" :
	\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction
