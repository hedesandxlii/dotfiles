set hidden
filetype plugin on

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
set colorcolumn=100

set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
set list

set wildignore=.git,*.o,*.class
set suffixes+=.old

call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline' 
Plug 'voldikss/vim-floaterm'
Plug 'mhinz/vim-startify'
Plug 'gruvbox-community/gruvbox'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

Plug 'nvie/vim-flake8', { 'for': 'python' }

call plug#end()

colorscheme gruvbox
highlight Normal guibg=none
highlight Comment cterm=italic

" Remaps!

let mapleader = ","
" Get coc keybinds and other stuff...
source $HOME/.config/nvim/coc_example_vim_cfg.vim

nnoremap <C-j> <C-w>j
nnoremap <C-h> <C-w>h
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <S-h> :bp<CR>
nnoremap <S-l> :bn<CR>

nnoremap <C-t> :FloatermNew ranger<CR>
nnoremap <leader>ev :e ~/.config/nvim/init.vim<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <F1> :set list! number! relativenumber!<CR> :call ToggleSignColumn()<CR>

augroup PythonStuff
    autocmd Filetype python nnoremap <leader>; :! python3 "%"<CR>
augroup END

augroup CppStuff
	autocmd Filetype cpp set noet
	autocmd Filetype cpp nnoremap <leader>m :! make<CR>
augroup END

augroup CStuff
	autocmd Filetype c set noet
	autocmd Filetype c nnoremap <leader>m :! make<CR>
augroup END

augroup JavaStuff
    autocmd Filetype java nnoremap <leader>; :!javac "%" && java "%:r"<CR>
    autocmd Filetype java inoremap sout System.out.println();<Esc>hi
augroup END

augroup MarkdownStuff
    autocmd Filetype markdown nnoremap <leader>; :! chrome "%"
augroup END

let g:coc_global_extensions = ['coc-jedi']
let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:flake8_show_in_gutter=1
let g:flake8_show_in_file=1

""""" cred to cherrot@StackOverflow [https://stackoverflow.com/a/53930943]

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
