" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup        " do not keep a backup file, use versions instead
set history=50      " keep 50 lines of command line history
set ruler           " show the cursor position all the time
set showcmd         " display incomplete commands
set incsearch       " do incremental searching

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

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

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
    au! BufRead,BufNewFile *.go setfiletype go
  augroup END

  " Limit the line length for this mode
  autocmd FileType markdown set tw=80

  au Syntax go runtime! ~/.vim/syntax/go.vim

else

  set autoindent        " always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

colorscheme elflord             " My favourite color scheme
set nowrap                      " No line wrapping
set expandtab                   " Expand tabs into spaces (company policy)

" Shift-tab to insert a hard tab
imap <silent> <S-tab> <C-v><tab>

set listchars=tab:>-,trail:.    " Make tabs and trailing spaces visible
set list                        " This enables the line above
hi SpecialKey guifg=#222222 guibg=black

set tabstop=4                   " Tabs are 4 characters wide (company policy)
set shiftwidth=4
set hlsearch                    " highlight search results
set smarttab
set number                      " show line numbers
set guioptions-=T               " I never need toolbar, but I need screen real
                                " estate
set ignorecase

" Assign comment-out-a-selected-block to Ctrl+K
"noremap <C-K>      :s/^/\/\//<CR>:noh<CR>

" Assign uncomment-a-selected-block to Ctrl+L
"noremap <C-L>       :s/^\/\///<CR>:noh<CR>

set encoding=utf-8
set fileencoding=utf-8
set tags+=tags;/

set spell
set spelllang=lt,en
" set spellfile=~/.vim/words.utf-8.add

set nobackup
set autoindent

set gfn=SourceCodePro\ 10

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
nnoremap <silent> <Leader>g :Ggrep <cword><cr>

" These two do the same thing:
nmap <silent> <leader>n :silent :nohlsearch<CR>
nnoremap <C-L> :nohls<CR><C-L>

set wildmenu
set wildmode=list:full
set title
set nojoinspaces
set ruler

set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Ignore these files when completing names and in Explorer
set wildignore=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.so,*.obj,*.swp

" use console dialogs instead of popup dialogs for simple choices
set guioptions+=c

set hidden
nnoremap ' `
nnoremap ` '

" C/H file switcher, a shortcut for this plugin:
" http://vim.sourceforge.net/scripts/script.php?script_id=31
nmap <silent> <leader>a :A <CR>

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
