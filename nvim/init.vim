filetype plugin indent on

set noerrorbells
set nowrap
set nohlsearch
set incsearch

set scrolloff=10
set number relativenumber
set completeopt=menu,menuone,preview,noinsert,noselect
set colorcolumn=80
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
set list

set expandtab             | " replace tabs with spaces
set autoindent            | " copies indent on new line
set tabstop=4             | " \
set shiftwidth=4          | "  )- These 3 makes <Tab> = 4.
set softtabstop=4         | " /

set hidden
set noswapfile nobackup nowritebackup
set undodir=~/.vim/undodir
set undofile

set wildignore=.git,*.o,*.class,**/__pycache__
set mouse=a

""" Plugins "
call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" Nice-to-have
Plug 'tpope/vim-commentary'

" Linting & Formatting
" Run `:ALEInfo` to see available/enabled linters
Plug 'dense-analysis/ale'
Plug 'tell-k/vim-autopep8'

" Colorschemes & visuals
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'NLKNguyen/papercolor-theme'

call plug#end()

set background=dark
colorscheme PaperColor
let g:airline_theme='papercolor'

"""     Remaps! "

let mapleader = ","
" Get coc keybinds and other stuff...
source $HOME/.config/nvim/coc_example_vim_cfg.vim

" Vim-like movement between `:make` errors "
nnoremap <C-n> :cn<CR>
nnoremap <C-p> :cp<CR>

" Vim-like movement between buffers "
nnoremap <S-h> :bp<CR>
nnoremap <S-l> :bn<CR>

nnoremap <C-j> :call MoveLine("down")<CR>
nnoremap <C-k> :call MoveLine("up")<CR>

" Hotkeys "
nnoremap <leader>ev :e ~/.config/nvim/init.vim<CR>
nnoremap <expr> <leader>f DirPresent(".git") ? ':GFiles<CR>' : ':Files<CR>'
nnoremap <leader>g :Rg<CR>
nnoremap <F1> :set list! number! relativenumber!<CR> :call ToggleSignColumn()<CR>
nnoremap Y y$ | " reasonable yanking
vnoremap <C-c> "*y

nnoremap <silent> <leader>; :make<CR>

autocmd Filetype python compiler python | " ~/.config/nvim/compiler/python.vim
autocmd Filetype python set foldmethod=indent
autocmd Filetype python set equalprg=autopep8\ - | " proper formatting
autocmd Filetype cpp set noet
autocmd Filetype c set noet

""" Config "
let g:coc_global_extensions = ['coc-jedi']
let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#tabline#enabled = 1

let g:ale_linters_explicit = 1
let g:ale_linters = {
        \ 'python': ['flake8', 'mypy'],
        \ }

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

function! DirPresent(path)
    if finddir(a:path, ".") == a:path
        return 1
    endif
    return 0
endfunction
