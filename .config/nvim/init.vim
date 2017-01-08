" * This will only work with neovim
" * See setup section for extra steps needed

" local
if filereadable(expand("~/.config/nvim/local.vim"))
  source ~/.config/nvim/local.vim
endif

set rtp+=~/.fzf                     " load FZF
set nocompatible                    " vundle, required
filetype off                        " vundle required

" Autoinstall vim-plug
"if empty(glob('~/.vim/autoload/plug.vim'))
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

" ## PLUGIN BEGIN ###
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'simnalamburt/vim-mundo'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'mileszs/ack.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'YankRing.vim'
Plug 'neomake/neomake'
call plug#end()
" ### PLUGIN END ###

" TODO:
" Snipmate
" Sparkup
" Yankring
" Surround
" Scratch
" Rainbow Parentheses
" Python PEP 8
" Deoplete or YouCompleteMe
" Neomake
" ### PLUGIN END ###

filetype plugin indent on    " vundle required

" ### GENERAL CONFIGS ###

let mapleader = "\<Space>"

set encoding=utf-8
set modelines=0         " needed for security, but I never work with modelines
set number              " relative numbers
set relativenumber      " relative numbers
set ignorecase          " ignore case when searching
set smartcase           " be smart when using case as a search arbiter (for exameple myFunction)
set scrolloff=5         " when searching, have a five line buffer around the cursor position
set showmode            " show the current editing mode
set hidden              " allow buffers to be hidden, instead of requests to close
set visualbell          " no bleeps
set wildmenu            " tab completion
set gdefault            " :%s/foo/bar instead of :%s/foo/bar/g
set incsearch
set showmatch
set hlsearch            " Highlight search results
set wrap                " wrap text
set textwidth=80        " Limit to 89 chars
set formatoptions=qrn1  " Required by character limit line

" vim-airline theme
" More can be seen here: https://github.com/vim-airline/vim-airline/wiki/Screenshots
let g:airline_theme='papercolor'

" Wildmenu ignores (conditional for machines that don't support wildmenu)
if has("wildmenu")
    set wildignore+=*.a,*.o,*.pyc
    set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
    set wildignore+=.DS_Store,.git,.hg,.svn
    set wildignore+=*~,*.swp,*.tmp
    set wildmenu
    set wildmode=longest:list,full
endif

" ### REMAPS ###

" respect line wraps when going up /down
nnoremap k gk
nnoremap j gj
nnoremap gk k
nnoremap gj j

" disable arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Make Y effect to end of line instead of whole line
map Y y$

" write file
nnoremap <leader>fs :w <cr>

" quit out
nnoremap <leader>q :q <cr>

" Cursor line highlighting
nnoremap <Leader>ch :set cursorline! <cr>

" No highlight
nnoremap <leader>noh :noh <cr>

" Save having to press shift everytime
nnoremap ; :

" ,W strip all whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Open up .vimrc in a split vert window
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>

" Set escape key to jj
inoremap jj <ESC>
tnoremap jj <ESC>

" ,m to toggle on visual line
function! g:ToggleColorColumn()
  if &colorcolumn != ''
    setlocal colorcolumn&
  else
    setlocal colorcolumn=+1
  endif
endfunction
nnoremap <silent> <leader>m :call g:ToggleColorColumn()<CR>

function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunc

nnoremap <leader>rn :call NumberToggle()<cr>

" MundoToggle
nnoremap <leader>au :MundoToggle<CR>

" ### Window Handling ###

" open vertical split window
nnoremap <leader>wv <C-w>v<C-w>l

" open a horizontal window
nnoremap <leader>wh <C-w>s<C-w>l

" Window Next
nnoremap <leader>wn :bnext<CR>
nnoremap <leader>wp :bprevious<CR>

" Navigate around windows <ctrl> h,j,k,l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

" ### Plugin Maps ###

" NerdTree Toggle
nmap <silent> <leader>nt :NERDTreeToggle<CR>

" Nerd Commenter
nnoremap <leader>co :call NERDComment(0,"toggle")<CR>
vnoremap <leader>co :call NERDComment(0,"toggle")<CR>

" Ack (try to use in a project, and not $HOME or /)
nmap <leader>a :tab split<CR>:Ack "" <Left>

" Ack search on current word
nmap <leader>A :tab split<CR>:Ack <C-r><C-w><CR>

" FZF
nnoremap <leader>fz :FZF<CR>

" Highlight Whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/

" YankRing
nnoremap <silent><leader>ys :YRShow<CR>

" ### TABS / INDENTS ###

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent

" ====================================== HELP ======================================
" Vundle:
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
" see :h vundle for more details or wiki for FAQ

" Remaps:
" `jj` escape remap
" `m` toggle 80 char width marker
" `fs` save file
" `q` quit file
" `hc` highlight cursorline
" `noh` turn off highlight
" `W` remove all whitespace
" `au` undo (j/k to select a tree node, `p` to preview, `return` to apply
" `Y` yanks to end of line, and not whole line (bring inline with `C` & `D`)
" `rn` Toggle Relative Numbers
" Windows:
" `ev` open .vimrc in a split window
" `wv` open vertical window
" `wh` open horizontal window
" `wn` next window
" `wp` previous window
" `hjkl` navigate around windows
" VimFugitve:
" <tbd>
" NerdTree:
" `nt` Toggle NerdTree
" NerdCommenter:
" `cc` Comment out the current line or text selected in visual mode.
" `cn` Same as cc but forces nesting.
" `c<space>` Toggles the comment state of the selected line(s).
" `ci` Toggles the comment state of the selected line(s) individually.
" `cs` Comments out the selected lines with a pretty block formatted layout.
" `cy` Same as cc except that the commented line(s) are yanked first.
" `c$` Comments the current line from the cursor to the end of line.
"  `cu` Uncomments the selected line(s).
" Ack:
" `a` type in string and search (use within a project folder, and not in ~/)
" `A` search for occurances of the word positioned under the cursor
" Mundo:
" `au` Start undo, hit return to select a tree, `p` preview.
" Repeat `au` to toggle close
" `u` perform simple undo
" YankRing:
" `ys` maps to YRShow to display register cache. Ctrl-P / Ctrl-N to select paste
" FZF:
" `fzf`
" ====================================== SETUP ======================================
" The following steps must be carried out manually
" $ pip2 install --user --upgrade neovim
" $ pip3 install --user --upgrade neovim
" :echo has("python3") # should return 1
" Consider some aliases:
" alias vim='nvim'
" Setup FZF:
" $ git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
" $ ~/.fzf/install
" Add the following to .vimrc
" set rtp+=~/.fzf
"
" TODO:
" toggle for `paste`
" open todo in a spilt window
" redo dotfiles
" shift+k (or j) move up by 10 spaces (used for large files)
" $source
" Holy cow: https://github.com/junegunn/fzf/wiki/examples http://seanbowman.me/blog/fzf-fasd-and-bash-aliases/
" Add upgrade check for FZF:
" cd ~/.fzf && git pull && ./install
" sync to desktop
" migrate to vim-plug
" write down terminal to vim edit ctrl-x +  ctrl-e
" write a decent ToDo with vim, and terminal aliases
