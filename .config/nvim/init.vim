let mapleader=" "
syntax on

set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set smartindent
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

call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'lervag/vimtex'
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
call plug#end()

let g:tex_flavor='latex'
let g:NERDTreeMapCustomOpen = "l"
let g:coc_global_extensions = [
  \ 'coc-clangd',
  \ 'coc-css',
  \ 'coc-html',
  \ 'coc-json',
  \ 'coc-pairs',
  \ 'coc-prettier',
  \ 'coc-python',
  \ 'coc-tsserver',
  \ 'coc-vimtex',
  \ 'coc-vetur'
  \ ]

vmap ++ <plug>NERDCommenterToggle
nmap ++ <plug>NERDCommenterToggle

nmap <leader>gh :diffget //3<CR>
nmap <leader>gu :diffget //2<CR>
nmap <leader>gs :G<CR>
nmap <leader>h :wincmd h<CR>
nmap <leader>j :wincmd j<CR>
nmap <leader>k :wincmd k<CR>
nmap <leader>l :wincmd l<CR>
nmap <Leader>+ :vertical resize +5<CR>
nmap <Leader>- :vertical resize -5<CR>
nmap <Leader>e :edit .<CR>
nmap <Leader>sv :vs <bar> :wincmd l <bar> :edit .<CR>
nmap <Leader>sh :sp <bar> :wincmd j <bar> :edit .<CR>
tnoremap <Esc> <C-\><C-n>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> K :call <SID>show_documentation()<CR>
nmap <leader>rn <Plug>(coc-rename)

augroup Terminal
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber
augroup END

function Shorttab()
    setlocal tabstop=2 softtabstop=2 shiftwidth=2
endfunction

augroup Tab
    autocmd!
    autocmd FileType javascript call Shorttab()
	autocmd FileType html call Shorttab()
	autocmd FileType css call Shorttab()
	autocmd FileType vue call Shorttab()
augroup END

highlight clear SignColumn
if has("patch-8.1.1564")
  set signcolumn=number
else
  set signcolumn=yes
endif

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

autocmd CursorHold * silent call CocActionAsync('highlight')
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

command! -nargs=0 Format :CocCommand prettier.formatFile
