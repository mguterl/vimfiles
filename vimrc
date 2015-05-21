set nocompatible                " choose no compatibility with legacy vi

" Required Vundle setup
filetype off
set runtimepath+=~/.vim/bundle/vundle
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'kchmck/vim-coffee-script'
Bundle 'rking/ag.vim'
Bundle 'compactcode/alternate.vim'
Bundle 'tpope/vim-commentary'
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-cucumber'
Bundle 'tpope/vim-fugitive'
Bundle 'rizzatti/funcoo.vim'
Bundle 'tpope/vim-haml'
Bundle 'nono/vim-handlebars'
Bundle 'compactcode/open.vim'
Bundle 'tpope/vim-rails'
Bundle 'thoughtbot/vim-rspec'
Bundle 'vim-ruby/vim-ruby'
Bundle 'tpope/vim-rvm'
Bundle 'jgdavey/tslime.vim'
Bundle 'tpope/vim-surround'
Bundle 'christoomey/vim-tmux-navigator'
Bundle 'scrooloose/nerdtree'
Bundle 'mxw/vim-jsx'
Bundle 'rizzatti/dash.vim'
Bundle 'mattn/emmet-vim'
Bundle 'jszakmeister/vim-togglecursor'
Bundle 'pangloss/vim-javascript'
Bundle 'tpope/vim-endwise'
Bundle 'itspriddle/vim-marked'
Bundle 'scrooloose/syntastic'
Bundle 'milkypostman/vim-togglelist'

" http://mislav.uniqpath.com/2011/12/vim-revisited/
syntax enable
set encoding=utf-8
set showcmd                     " display incomplete commands
filetype plugin indent on       " load file type plugins + indentation
set incsearch                   " do incremental searching

"" Keep backup and .swp files out of the working directory
"" http://stackoverflow.com/a/15317146/86820
set backupdir=~/tmp//
set directory=~/tmp//

"" Whitespace
set nowrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

let mapleader=","

" make the mouse work in the terminal
set mouse=a

" disable cursor keys in normal mode
map <Left>  :echo "no!"<cr>
map <Right> :echo "no!"<cr>
map <Up>    :echo "no!"<cr>
map <Down>  :echo "no!"<cr>

" easier navigation between split windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" split the right way
set splitbelow
set splitright

" turn on line numbers
set number

" clear the search buffer when hitting return
:nnoremap <CR> :nohlsearch<cr>

" paste lines from unnamed register and fix indentation
nmap <leader>p pV`]=
nmap <leader>P PV`]=

function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

" whitespace
set nolist listchars=tab:·\ ,eol:¶,trail:·,extends:»,precedes:«
nmap <silent> <leader>w :set nolist!<CR>

function! <SID>StripTrailingWhitespaces()
  call Preserve("%s/\\s\\+$//e")
endfunction

nnoremap <silent> <F5> :call <SID>StripTrailingWhitespaces()<CR>

" strip whitespace on save
autocmd BufWritePre *.rb,*.coffee,*.py,*.js :call <SID>StripTrailingWhitespaces()

" theme
let g:pencil_higher_contrast_ui=1
colorscheme pencil

" rspec / tmux integration
let g:rspec_command = 'call Send_to_Tmux("rspec {spec}\n")'

" Rspec.vim mappings
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

" Markdown
let g:vim_markdown_folding_disabled=1      " don't do folding

" Treat hamlc as haml
au BufRead,BufNewFile *.hamlc set ft=haml

set statusline=%F%m%r%h%w\
set statusline+=%{fugitive#statusline()}\
set statusline+=[%{strlen(&fenc)?&fenc:&enc}]
set statusline+=\ [line\ %l\/%L]
set statusline+=\ [col\ %v]
set laststatus=2

set tags=./tags,tags,.git/tags

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PROMOTE VARIABLE TO RSPEC LET
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
:map <leader>l :PromoteToLet<cr>

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command =
    \ 'ag %s --files-with-matches -g "" --ignore "\.git$\|\.hg$\|\.svn$"'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Explicitly use --vimgrep to avoid extra rows in quickfix.
let g:ag_prg="ag --vimgrep"

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Emacs-like beginning and end of line.
imap <c-e> <c-o>$
imap <c-a> <c-o>^

" Disable Ex mode
map Q <Nop>

" Disable K looking stuff up
map K <Nop>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE (thanks Gary Bernhardt)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <Leader>n :call RenameFile()<cr>

map <C-s> :w<CR>
imap <C-s> <C-c>:w<CR>

" delete buffer without losing the split window
nnoremap <leader>c :bp\|bd #<CR>

nnoremap <Leader>h :OpenHorizontal(alternate#FindAlternate())<CR>
nnoremap <Leader>v :OpenVertical(alternate#FindAlternate())<CR>

" Run the test for the current file
autocmd FileType ruby   nnoremap <buffer> <Leader>r :execute "! rspec " . alternate#FindTest() <CR>

:nmap <silent> <leader>d <Plug>DashSearch

" syntastic configuration
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_ruby_checkers = ["mri", "rubocop"]
let g:syntastic_cucumber_checkers = []

" Open NERDTree if no files are specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Toggle NERDTree
map <C-n> :NERDTreeToggle<CR>

" Show hidden files
let NERDTreeShowHidden=1

" Resize splits with mouse in tmux
" http://superuser.com/a/550482
set mouse+=a
if &term =~ '^screen'
    " tmux knows the extended mouse mode
    set ttymouse=xterm2
endif

nmap <script> <silent> <leader>l :call ToggleLocationList()<CR>
nmap <script> <silent> <leader>q :call ToggleQuickfixList()<CR>
