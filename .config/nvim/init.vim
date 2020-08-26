let mapleader=" "
syntax on

set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
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
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'ryanoasis/vim-devicons'
call plug#end()

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
  \ 'coc-vimtex'
  \ ]

vmap ++ <plug>NERDCommenterToggle
nmap ++ <plug>NERDCommenterToggle

nmap <C-n> :NERDTreeToggle<CR>
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <Leader>+ :vertical resize +5<CR>
nnoremap <Leader>- :vertical resize -5<CR>
nnoremap <Leader>e :edit .<CR>
nnoremap <Leader>sv :vs <bar> :wincmd l <bar> :edit .<CR>
nnoremap <Leader>sh :sp <bar> :wincmd j <bar> :edit .<CR>
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

if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')

command! -nargs=0 Format :CocCommand prettier.formatFile
