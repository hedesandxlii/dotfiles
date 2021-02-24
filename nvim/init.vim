
set hidden

set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nowrap

set noerrorbells
set number relativenumber
set nohlsearch
set incsearch
set scrolloff=8

set noswapfile nobackup nowritebackup
set undodir=~/.vim/undodir
set undofile

set completeopt=menuone,noinsert,noselect
set colorcolumn=80


call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline' 
Plug 'voldikss/vim-floaterm'
Plug 'gruvbox-community/gruvbox'

Plug 'neoclide/coc.nvim', { 'branch': 'release' }
call plug#end()

colorscheme gruvbox
highlight Normal guibg=none

" Remaps!
let mapleader = ","
nnoremap <C-j> <C-w>j
nnoremap <C-h> <C-w>h
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <S-h> :bp<CR>
nnoremap <S-l> :bn<CR>

" nnoremap <C-d> :term<CR>
" tnoremap <Esc> <C-\><C-n>

nnoremap <leader>; :terminal make "%:r" && ./"%:r"<CR>i
nnoremap <leader>ev :e ~/.config/nvim/init.vim<CR>
nmap <C-t> :FloatermNew ranger<CR>

" Get coc keybinds and other stuff...
source $HOME/.config/nvim/coc_example_vim_cfg.vim
let g:coc_global_extensions = ['coc-jedi', 'coc-json']

let g:airline#extensions#tabline#enabled = 1
