"Options
filetype plugin indent on

set autoindent
set background=dark
set clipboard=unnamedplus
set cursorline
set encoding=utf-8
set hlsearch
set ignorecase
set laststatus=2
set lazyredraw
set linebreak
set mouse=a
set nocompatible
set noshowmode
set number
set rtp+=/usr/share/powerline/bindings/vim
set ruler
set shiftwidth=4
set showbreak=++++
set showcmd
set showmatch
set smartcase
set smartindent
set smarttab
set softtabstop=4
set textwidth=120
set timeout
set timeoutlen=3000
set ttimeoutlen=100

if exists('+termguicolors')
    let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors "Enable 24-bit colors
else
set t_Co=256 "Fallback to 8-bit colors
endif

"Bindings
noremap <C-Up> ddkP
noremap <C-Down> ddp
noremap <C-L> :let @/ = ""<CR>

noremap i k
noremap k j
noremap j h
noremap h i

noremap I H
noremap H I

nnoremap <C-S-tab> :tabprevious<CR>
nnoremap <C-tab>   :tabnext<CR>
nnoremap <C-t>     :tabnew<CR>
nnoremap <C-w>     :tabclose<CR>

inoremap <C-S-tab> <Esc>:tabprevious<CR>i
inoremap <C-tab>   <Esc>:tabnext<CR>i
inoremap <C-t>     <Esc>:tabnew<CR>
inoremap <C-w>     <Esc>:tabclose<CR>

"Plugins
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'tomasiser/vim-code-dark'
Plug 'farmergreg/vim-lastplace'
Plug 'Valloric/YouCompleteMe' , { 'do': './install.py' }
call plug#end()

"Plugin settings
colorscheme codedark
let g:ycm_key_list_stop_completion = ['<CR>']
