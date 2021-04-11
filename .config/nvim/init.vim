let mapleader=" "
syntax on

set noerrorbells
set noexpandtab
set tabstop=4 softtabstop=4
set shiftwidth=4
set nu
set nowrap
set smartcase
set smartindent
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

call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'morhetz/gruvbox'
call plug#end()

colorscheme gruvbox
set background=dark

let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDTreeMapCustomOpen = "l"
let g:coc_global_extensions = [
	\ 'coc-clangd',
	\ 'coc-css',
	\ 'coc-eslint',
	\ 'coc-html',
	\ 'coc-json',
	\ 'coc-lua',
	\ 'coc-pairs',
	\ 'coc-python',
	\ 'coc-vetur',
	\ 'coc-vimtex',
	\ ]

nnoremap ++ <plug>NERDCommenterToggle
nnoremap <leader>gh :diffget //2<CR>
nnoremap <leader>gl :diffget //3<CR>
nnoremap <leader>gs :G<CR>
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <Leader>+ :vertical resize +5<CR>
nnoremap <Leader>- :vertical resize -5<CR>
nnoremap <Leader>e :edit .<CR>
nnoremap <Leader>sv :vs <bar> :wincmd l <bar> :edit .<CR>
nnoremap <Leader>sh :sp <bar> :wincmd j <bar> :edit .<CR>
nnoremap <Leader>t :tabedit <bar> :edit .<CR>
nnoremap <silent><leader>gd <Plug>(coc-definition)
nnoremap <silent><leader>gy <Plug>(coc-type-definition)
nnoremap <silent><leader>gi <Plug>(coc-implementation)
nnoremap <silent><leader>gr <Plug>(coc-references)
nnoremap <silent><leader>K :call <SID>show_documentation()<CR>
nnoremap <leader>rn <Plug>(coc-rename)
nnoremap <silent><expr> ZZ or(expand('%:t') !~ '^NERD.*', winnr('$') == 1) ? ':wq<CR>' : ':NERDTreeClose<CR>'
nnoremap <silent><expr> ZQ or(expand('%:t') !~ '^NERD.*', winnr('$') == 1) ? ':q!<CR>' : ':NERDTreeClose<CR>'

tnoremap <Esc> <C-\><C-n>
vnoremap ++ <plug>NERDCommenterToggle
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<C-G>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function Shorttab()
	setlocal tabstop=2 softtabstop=2 shiftwidth=2
endfunction

augroup custom
	autocmd!
	autocmd TermOpen * setlocal nonumber norelativenumber
	autocmd FileType html call Shorttab()
	autocmd FileType javascript call Shorttab()
	autocmd FileType css call Shorttab()
	autocmd FileType vue call Shorttab()
	autocmd FileType json call Shorttab()
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
