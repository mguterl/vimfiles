set nocompatible                " choose no compatibility with legacy vi

" Required Vundle setup
filetype off
set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'kchmck/vim-coffee-script'
Plugin 'rking/ag.vim'
Plugin 'compactcode/alternate.vim'
Plugin 'tpope/vim-commentary'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-cucumber'
Plugin 'tpope/vim-fugitive'
Plugin 'rizzatti/funcoo.vim'
Plugin 'tpope/vim-haml'
Plugin 'compactcode/open.vim'
Plugin 'tpope/vim-rails'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-rvm'
Plugin 'jgdavey/tslime.vim'
Plugin 'tpope/vim-surround'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'scrooloose/nerdtree'
Plugin 'mxw/vim-jsx'
Plugin 'rizzatti/dash.vim'
Plugin 'mattn/emmet-vim'
Plugin 'jszakmeister/vim-togglecursor'
Plugin 'pangloss/vim-javascript'
Plugin 'tpope/vim-endwise'
Plugin 'itspriddle/vim-marked'
Plugin 'scrooloose/syntastic'
Plugin 'elixir-lang/vim-elixir'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'janko-m/vim-test'

call vundle#end()

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
colorscheme zenburn

" vim-test
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>
let g:test#ruby#minitest#executable = 'm'
let g:test#ruby#m#file_pattern = '\v(_spec\.rb|_test\.rb)$'
let g:test#strategy = 'tslime'

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

" http://blog.mikecordell.com/2015/01/27/better-fuzzy-search-with-ctrl-p-in-vim.html
if executable('matcher')
    let g:ctrlp_match_func = { 'match': 'GoodMatch' }

    function! GoodMatch(items, str, limit, mmode, ispath, crfile, regex)
      " Create a cache file if not yet exists
      let cachefile = ctrlp#utils#cachedir().'/matcher.cache'
      if !( filereadable(cachefile) && a:items == readfile(cachefile) )
        call writefile(a:items, cachefile)
      endif
      if !filereadable(cachefile)
        return []
      endif

      " a:mmode is currently ignored. In the future, we should probably do
      " something about that. the matcher behaves like "full-line".
      let cmd = 'matcher --limit '.a:limit.' --manifest '.cachefile.' '
      if !( exists('g:ctrlp_dotfiles') && g:ctrlp_dotfiles )
        let cmd = cmd.'--no-dotfiles '
      endif
      let cmd = cmd.a:str

      return split(system(cmd), "\n")
    endfunction
end

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
let g:syntastic_javascript_checkers = ["eslint"]
let g:syntastic_ruby_checkers = ["mri", "rubocop"]
let g:syntastic_cucumber_checkers = []
let g:syntastic_filetype_map = { 'html.handlebars': 'handlebars' }
let g:syntastic_handlebars_checkers = ["handlebars"]

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
