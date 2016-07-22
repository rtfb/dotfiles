
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'tpope/vim-unimpaired'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'ervandew/supertab'
Plugin 'tmhedberg/matchit'
Plugin 'kien/ctrlp.vim'
Plugin 'fatih/vim-go'
Plugin 'SirVer/ultisnips'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

let g:go_fmt_command = 'goimports'
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
let g:go_metalinter_autosave = 1
let g:go_metalinter_deadline = "5s"

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif


" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set whichwrap+=<,>,h,l

set history=500     " keep 500 lines of command line history
set showcmd         " display incomplete commands
set incsearch       " do incremental searching
set colorcolumn=81  " nag myself about long lines

" Fast saving
nmap <leader>w :w!<cr>

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hidden

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " Don't expand tabs in .go files
  autocmd FileType go setlocal noexpandtab

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

  " Help autodetection
  augroup filetypedetect
    au! BufRead,BufNewFile *.mdwn setfiletype markdown
  augroup END

  " Limit the line length for this mode
  autocmd FileType markdown set tw=80

  " No color column and spell checking in man pages
  autocmd FileType man set colorcolumn=0
  autocmd FileType man set nospell

endif " has("autocmd")

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                          \ | wincmd p | diffthis
endif

colorscheme elflord             " My favourite color scheme
set background=dark
set nowrap                      " No line wrapping
set expandtab                   " Expand tabs into spaces (company policy)

" Shift-tab to insert a hard tab
imap <silent> <S-tab> <C-v><tab>

set listchars=tab:>-,trail:.    " Make tabs and trailing spaces visible
set list                        " This enables the line above
highlight SpecialKey guifg=#222222 guibg=black

highlight ExtraWhitespaceR ctermbg=red guibg=red
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
nnoremap <silent> <Leader>s :match ExtraWhitespace /\s\+$/<cr>
nnoremap <silent> <Leader>rs :match ExtraWhitespaceR /\s\+$/<cr>
nnoremap <silent> <Leader>ns :match<cr>
match ExtraWhitespace /\s\+$/

set tabstop=4                   " Tabs are 4 characters wide (company policy)
set shiftwidth=4
set smarttab
set number                      " show line numbers

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T           " I never need toolbar, but I need screen real
                                " estate
    set guioptions-=m           " no menu either
    set guioptions-=e           " no GUI tabs
    set guioptions+=c           " use console dialogs instead of popup dialogs
                                " for simple choices
endif

set ignorecase

" When searching try to be smart about cases
set smartcase

set encoding=utf-8
set fileencoding=utf-8
set tags+=tags;/

" Use Unix as the standard file type
set ffs=unix,dos,mac

set spell
set spelllang=lt,en
" set spellfile=~/.vim/words.utf-8.add

set nobackup
set nowb
set noswapfile
set autoindent
set smartindent

if has("mac")
    set gfn=Source\ Code\ Pro:h14
else
    set gfn=SourceCodePro\ 10
endif

let g:load_doxygen_syntax=1

let g:po_translator = "Vytautas Šaltenis <Vytautas.Shaltenis@gmail.com>"
let g:po_lang_team = "Lietuvių <komp_lt@konf.lt>"
let g:po_path="/home/rtfb/hacking/wesnoth"

" Copied from here: http://vim.wikia.com/wiki/Exchanging_adjacent_words
" Swap word with next word
nmap <silent> gw    "_yiw:s/\v(<\k*%#\k*>)(\_.{-})(<\k+>)/\3\2\1/<cr><c-o><c-l>

" from here: http://vim.wikia.com/wiki/Highlight_long_lines
"nnoremap <silent> <Leader>l
"      \ :if exists('w:long_line_match') <Bar>
"      \   silent! call matchdelete(w:long_line_match) <Bar>
"      \   unlet w:long_line_match <Bar>
"      \ elseif &textwidth > 0 <Bar>
"      \   let w:long_line_match = matchadd('ErrorMsg', '\%>'.&tw.'v.\+', -1) <Bar>
"      \ else <Bar>
"      \   let w:long_line_match = matchadd('ErrorMsg', '\%>80v.\+', -1) <Bar>
"      \ endif<CR>

nnoremap <silent> <Leader>l /\%>80v.\+<cr>
nnoremap <silent> <Leader>gg :Ggrep <cword><cr>

" These two do the same thing:
nmap <silent> <leader><cr> :silent :nohlsearch<CR>
nnoremap <C-L> :nohls<CR><C-L>

set wildmenu
set wildmode=list:full
set title
set nojoinspaces
set ruler

set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Ignore these files when completing names and in Explorer
set wildignore=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.so,*.obj,*.swp,*.pyc

nnoremap ' `
nnoremap ` '

map <C-H> <C-W>h<C-W>_
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
map <C-L> <C-W>l<C-W>_

" More info here: http://vim.wikia.com/wiki/Maximize_or_set_initial_window_size
if has("gui_running")
  " GUI is running or is about to start.
  " Maximize gvim window.
  set lines=32 columns=228
endif

" Recursively set the path of the project.
" set path=$PWD/**

" Taken from here: http://www.mail-archive.com/vim@vim.org/msg11890.html
:hi Pmenu      ctermfg=Cyan    ctermbg=Blue cterm=None guifg=Cyan guibg=DarkBlue
:hi PmenuSel   ctermfg=White   ctermbg=Blue cterm=Bold guifg=White guibg=DarkBlue gui=Bold
:hi PmenuSbar                  ctermbg=Cyan            guibg=Cyan
:hi PmenuThumb ctermfg=White                           guifg=White

:hi CursorLine   cterm=NONE ctermbg=darkblue guibg=darkblue
:hi CursorColumn cterm=NONE ctermbg=darkblue guibg=darkblue
:nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>

set foldmethod=marker
set foldmarker=BEGIN\ EX,END\ EX

nmap <silent> gr :tabprev<cr>

set runtimepath^=~/.vim/bundle/ctrlp.vim
nnoremap <silent> <Leader>f :CtrlP<cr>

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

nnoremap <Insert> "*p<CR>
inoremap <Insert> <Esc>"*pa

""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ P:\ %l,\ %c

" Delete trailing white space
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimgrep searching and cope displaying
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv')<CR>

" Open vimgrep and put the cursor in the right position
map <leader>g :vimgrep // **/*<left><left><left><left><left><left>

" Vimgreps in the current file
map <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with vimgrep, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
map <leader>cc :botright cope<cr>
map <leader>n :cn<cr>
map <leader>p :cp<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scripbble
map <leader>q :e ~/buffer<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

" A quick workaround to avoid error highlight for C++11 lambdas
let c_no_curly_error=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction
