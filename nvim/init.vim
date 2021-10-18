filetype plugin indent on

" visuals
set nowrap
set noerrorbells
set number relativenumber
set nohlsearch
set incsearch
set scrolloff=8
set completeopt=menuone,noinsert,noselect
set colorcolumn=100
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
set list
set lazyredraw

" files
set noswapfile nobackup nowritebackup
set undodir=~/.vim/undodir
set undofile
set wildignore=.git,*.o,*.class
set suffixes+=.old

" misc
set mouse=a
set hidden

" tabs & whitespace
set autoindent   " start new line on same indentation level
set shiftwidth=4 " #spaces per autoindent
set expandtab    " use spaces instead of tab ("\t")
set tabstop=4    " <Tab> == 4 spaces
set smarttab

""" Plugins "
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline' 
Plug 'mhinz/vim-startify'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

Plug 'gruvbox-community/gruvbox'
call plug#end()

colorscheme gruvbox
highlight Normal guibg=none
highlight Comment cterm=italic

"""     Remaps! "

let mapleader = ","
" Get coc keybinds and other stuff...
source $HOME/.config/nvim/coc_example_vim_cfg.vim

" Vim-like movement between panes "
" nnoremap <C-j> <C-w>j
" nnoremap <C-h> <C-w>h
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l
nnoremap <C-j> :cn<CR>
nnoremap <C-k> :cp<CR>

" Vim-like movement between buffers "
nnoremap <S-h> :bp<CR>
nnoremap <S-l> :bn<CR>

" Vim-like move of current line "
nnoremap J :call MoveLine("down")<CR>
nnoremap K :call MoveLine("up")<CR>
" Join -> Merge
nnoremap M J

" Hotkeys "
nnoremap <C-t> :FloatermNew ranger<CR>
nnoremap <leader>ev :e ~/.config/nvim/init.vim<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <F1> :set list! number! relativenumber!<CR> :call ToggleSignColumn()<CR>

nnoremap <silent> <leader>; :make<CR>

autocmd Filetype python compiler python  " ~/.config/nvim/compiler/python.vim

autocmd Filetype cpp set noet
autocmd Filetype c set noet
autocmd Filetype java inoremap sout System.out.println();<Esc>hi

""" Config "
let g:coc_global_extensions = ['coc-jedi']
let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:flake8_show_in_gutter=1
let g:flake8_show_in_file=1

let $PYTHONUNBUFFERED=1

""" Functions "

" cred to cherrot@StackOverflow [https://stackoverflow.com/a/53930943]
" Toggle signcolumn. Works on vim>=8.1 or NeoVim
function! ToggleSignColumn()
    if !exists("b:signcolumn_on") || b:signcolumn_on
        set signcolumn=no
        let b:signcolumn_on=0
    else
        set signcolumn=number
        let b:signcolumn_on=1
    endif
endfunction

" moves a line and auto-indents affected lines
function! MoveLine(up_or_down)
    normal dd
    if a:up_or_down == "down"
        normal p=kj^
    elseif a:up_or_down == "up"
        if line('.') != line('$') | normal k
        endif
        normal P=j
    else
        echom "Invalid argument to MoveLine(): '" . a:up_or_down . "'"
    endif
endfunction
