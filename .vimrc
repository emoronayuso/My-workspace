"---------------------------------------------
" Neobundle config
"---------------------------------------------
filetype off                   " required by vundle

" Auto installing NeoBundle
let iCanHazNeoBundle=1
let neobundle_readme=expand($HOME.'/.vim/bundle/neobundle.vim/README.md')
if !filereadable(neobundle_readme)
    echo "Installing NeoBundle.."
    echo ""
    silent !mkdir -p $HOME/.vim/bundle
    silent !git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
    let iCanHazNeoBundle=0
endif

" Call NeoBundle
 if has('vim_starting')
     set nocompatible
     "set rtp+=$HOME/.vim/bundle/neobundle.vim/
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

"call neobundle#rc(expand($HOME.'/.vim/bundle/'))
call neobundle#begin(expand('~/.vim/bundle/'))

" is better if NeoBundle rules NeoBundle (needed!)
"NeoBundle 'Shougo/neobundle.vim'

NeoBundle 'Shougo/neobundle.vim'



" Installed bundles
"------------------

" Rust syntax
NeoBundle 'wting/rust.vim'
" Markdown sytax
NeoBundle 'plasticboy/vim-markdown'
" Airline
NeoBundle 'bling/vim-airline'
" Autocomplete for (, [, {, ', " ...
NeoBundle 'delimitMate.vim'
" Wombat colorscheme
NeoBundle 'vim-scripts/wombat256.vim'
" Molokai colorscheme
NeoBundle 'joedicastro/vim-molokai256'
" Jellybeans colorscheme
NeoBundle 'nanotech/jellybeans.vim'
" Notes plugin
"NeoBundle 'xolox/vim-notes'
"NeoBundle 'xolox/vim-misc'
" Undo tree
"NeoBundle 'sjl/gundo.vim'
" System commands (move, delete)
NeoBundle 'tpope/vim-eunuch'
" Simple comments
NeoBundle 'tpope/vim-commentary'
" Ack inside vim
NeoBundle 'mileszs/ack.vim'
" Show tags bar
NeoBundle 'majutsushi/tagbar'
" Show indent lines
" NeoBundle 'Yggdroot/indentLine'
" Auto-complete
" NeoBundle 'Valloric/YouCompleteMe'


"if has('lua')
"    NeoBundle 'Shougo/neocomplete.vim'
"end


" Auto-format
"NeoBundle 'Chiel92/vim-autoformat'
" Navigation sidebar
NeoBundle 'scrooloose/nerdtree'
" Surround text
NeoBundle 'tpope/vim-surround'
" Repeat comment or surround
NeoBundle 'tpope/vim-repeat'
" Zen coding (html & css)
"NeoBundle 'mattn/emmet-vim'
" PHP & html correct indent
" NeoBundle 'vim-scripts/php.vim-html-enhanced'
" DirDiff
" NeoBundle 'vim-scripts/DirDiff.vim'

call neobundle#end()

" non github repos
" ex - NeoBundle 'git://git.example.com/repo.git'






"---------------------------------------------
" General config
"---------------------------------------------

" various options
syntax enable
filetype plugin indent on       " load file type plugins + indentation
set encoding=utf-8              " set encoding to UTF-8
set showcmd                     " display incomplete commands
set laststatus=2                " always display a status line at the bottom of the window
set noswapfile                  " disable swap files
set autoread                    " auto-reload external file changes
set ttymouse=xterm2             " set mouse style
set mouse=a                     " enable mouse
set nodigraph

" Whitespace
set tabstop=4 shiftwidth=4      " tab of Kernel coding style
" Kernel Coding Style
autocmd Bufenter *.c,*.h set noexpandtab tabstop=8 shiftwidth=8 colorcolumn=80
set expandtab                   " use spaces, not tabs
set backspace=indent,eol,start  " backspace through everything in insert mode

" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

" Line numbers
set number                      " show line numbers
set cursorline                  " highlight the line of the cursor

" Color
set t_Co=256
color jellybeans

" Folding
set foldmethod=marker
set nofoldenable

" Gvim options
set guifont=Inconsolata\ 14
set guioptions-=m " remove menu bar
set guioptions-=T " remove toolbar
set guioptions+=LlRrb " next line need this
set guioptions-=LlRrb " remove scrool bars
set guicursor=a:block-Cursor " block cursor for all modes
set guicursor=a:blinkon0 " disable cursor blink
" copy to clipboard
vmap <C-c> "+y
" cut to clipboard
vmap <C-x> "+c
" paste from clipboard
vmap <C-v> c<ESC>"+p
imap <C-v> <C-r><C-o>+

" Autocomplete Ctr+space
inoremap <Nul> <C-n>

" Leader and LocalLeader map
let mapleader=','
let maplocalleader= '\'

" Quick search and replace
vmap <Leader>r "sy:%s/<C-R>=substitute(@s,"\n",'\\n','g')<CR>/

"Copy all
nnoremap <C-a> ggmqVG"+y'q

" Show hidden characters
nmap <leader>o :set list!<CR>
set listchars=tab:→\ ,eol:↵,trail:·,extends:↷,precedes:↶

" Delete trailing spaces
nmap <Leader>rt :%s/\s\+$//<CR>

" Toggle line wrap
nnoremap <Leader>w :call ToggleWrapLines() <CR>
function! ToggleWrapLines()
    if &wrap
        set nowrap
    else
        set wrap
    endif
endfunction

" Toggle line numbers
nnoremap <Leader>l :call ToggleRelativeAbsoluteNumber()<CR>
function! ToggleRelativeAbsoluteNumber()
  if !&number && !&relativenumber
      set number
      set norelativenumber
  elseif &number && !&relativenumber
      set nonumber
      set relativenumber
  elseif !&number && &relativenumber
      set number
      set relativenumber
  elseif &number && &relativenumber
      set nonumber
      set norelativenumber
  endif
endfunction

" Toggle paste mode
set pastetoggle=<F3>

" Toggle folding
map <Leader>f :set invfoldenable<CR>
" nnoremap <Space> za
" vnoremap <Space> za

" Clear last search highlighting
map <Leader>sq :nohlsearch<CR>

" Save as root
cmap w!! w !sudo tee % >/dev/null<CR>:e!<CR><CR>

"---------------------------------------------
" Plugins config
"---------------------------------------------

" Notes config
highlight notesXXX ctermfg=2

" Gundo
nnoremap <Leader>u :GundoToggle<CR>
let g:gundo_preview_bottom = 1

" Vim-commentary
nmap <leader>c <Plug>CommentaryLine
xmap <leader>c <Plug>Commentary

" Ack
map <Leader>a :Ack!<Space>

" Tagbar
map <Leader>tb :TagbarToggle<CR>
let g:tagbar_autoclose = 1
let g:tagbar_left = 1
let g:tagbar_autofocus = 1
let g:tagbar_sort = 0
let g:tagbar_compact = 1
let g:tagbar_autoshowtag = 1

" IndentLine
" map <silent> <Leader>sl :IndentLinesToggle<CR>
" let g:indentLine_enabled = 0
" let g:indentLine_char = '¦'
" let g:indentLine_char = '┆'
" let g:indentLine_color_term = 239

" Autoformat
" noremap <F4> :Autoformat<CR><CR>

" NerdTree
map <Leader>t :NERDTreeToggle<CR>

" Revisar ortografía en español
nmap <Leader>ss :setlocal spell spelllang=es<cr>
" Revisar ortografía en inglés
nmap <Leader>se :setlocal spell spelllang=en<cr>
" Desactivar revisión ortográfica
nmap <Leader>so :setlocal nospell <cr>
" " Ir a la siguiente palabra mal escrita
" nmap <Leader>sn ]s"
" suggest words
nmap <Leader>sp z=

" Zen Coding
let g:user_zen_mode='a'

"Airline
set noshowmode

let g:airline_theme='jellybeans'
" let g:airline_theme='powerlineish'
let g:airline_enable_branch=1
let g:airline_powerline_fonts=0
let g:airline_detect_whitespace = 1
let g:airline_symbols = {}
let g:airline_symbols.whitespace = '!'
let g:airline_left_sep = ''
let g:airline_right_sep = ''

" Neocomplete
 let g:neocomplete#enable_at_startup = 1

set spelllang=es,en

