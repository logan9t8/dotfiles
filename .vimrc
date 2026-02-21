"---Options---

filetype plugin indent on
syntax on

set autocomplete
set autoindent
set background=dark
set clipboard=unnamedplus
set complete+=o^5
set completeopt=menuone,noinsert
set cursorline
set encoding=utf-8
set hlsearch
set ignorecase
set keymodel=startsel
set laststatus=2
set lazyredraw
set linebreak
set mouse=a
set nocompatible
set noshowmode
set number
set omnifunc=syntaxcomplete#Complete
set pumheight=10
set rtp+=/usr/share/powerline/bindings/vim
set ruler
set shiftwidth=4
set shortmess+=c
set showbreak=++++
set showcmd
set showmatch
set smartcase
set smartindent
set smarttab
set softtabstop=4
set termguicolors 
set textwidth=120
set timeoutlen=300
set ttimeoutlen=100
set wildmenu

"---Hacks---

"Clipboard for WSL
if system('uname -r') =~? 'microsoft'
    "Visual mode - Selection copy
    vnoremap <C-c> y:call system('clip.exe', @")<CR>gv
    "Normal mode - Line copy
    nnoremap yy yy:call system('clip.exe', @")<CR>
    "Normal mode - Line paste
    nnoremap p :r !powershell.exe -NoProfile -NoLogo -Command Get-Clipboard<CR>
endif

"Autocomplete for paths
augroup AutoPathComplete
  autocmd!
  autocmd InsertCharPre * if v:char == '/' | call feedkeys("\<C-x>\<C-f>", 'n') | endif
  autocmd CompleteDone * if getline('.')[col('.')-2] ==# '/' | call feedkeys("\<C-x>\<C-f>", 'n') | endif
augroup END

"---Bindings---

"Tab completions navigation
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-tab>"
inoremap <expr> <Esc> pumvisible() ? "\<C-e>" : "\<Esc>"

"Move lines up and down
noremap <C-Up> ddkP
noremap <C-Down> ddp

"Clear search highlight
noremap <C-L> :let @/ = ""<CR>

"Remap movement keys like wasd
noremap i k
noremap k j
noremap j h
noremap h i

"Remap page movement keys
noremap I H
noremap H I
noremap L K
noremap K L

"Tab management
nnoremap <C-S-tab> :tabprevious<CR>
nnoremap <C-tab>   :tabnext<CR>
nnoremap <C-t>     :tabnew<CR>
nnoremap <C-w>     :tabclose<CR>

inoremap <C-S-tab> <Esc>:tabprevious<CR>i
inoremap <C-tab>   <Esc>:tabnext<CR>i
inoremap <C-t>     <Esc>:tabnew<CR>
inoremap <C-w>     <Esc>:tabclose<CR>

"---Plugins---

"Install vim-plug if not already installed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'tomasiser/vim-code-dark'
Plug 'farmergreg/vim-lastplace'
Plug 'tpope/vim-commentary'
Plug 'preservim/nerdtree'
call plug#end()

"---Plugin settings---

colorscheme codedark
"_ means /
nnoremap <C-_>     :Commentary<CR>
inoremap <C-_>     <Esc>:Commentary<CR>i
xnoremap <C-_>     :Commentary<CR>
nnoremap <C-b>     :NERDTreeToggle<CR>
inoremap <C-b>     <Esc>:NERDTreeToggle<CR>i

