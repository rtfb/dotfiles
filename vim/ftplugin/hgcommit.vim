" Vim filetype plugin
" Language:	git commit file
" Maintainer:	Tim Pope <vimNOSPAM@tpope.org>
" Last Change:	2012 April 7

" Only do this when not done yet for this buffer
if (exists("b:did_ftplugin"))
  finish
endif

let b:did_ftplugin = 1

setlocal nomodeline formatoptions-=croq formatoptions+=tl

let b:undo_ftplugin = 'setl modeline< formatoptions<'

if &textwidth == 0
  " make sure that log messages play nice with git-log on standard terminals
  setlocal textwidth=72
  let b:undo_ftplugin .= "|setl tw<"
endif

if filereadable($HOME.'/.vim/ftplugin/hgcommit-prefix.vim')
    source $HOME/.vim/ftplugin/hgcommit-prefix.vim
endif
