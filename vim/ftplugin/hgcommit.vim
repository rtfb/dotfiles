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

setlocal textwidth=72
let b:undo_ftplugin .= "|setl tw<"

function! Strip(input_string)
    return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

let g:commit_prefixes = {
    \ 'foo': 'bar',
    \ }

" This file should contain additional entries for the above dict, in the form:
" let g:commit_prefixes['http://repo.url'] = 'commit prefix: '
if filereadable($HOME.'/.vim/ftplugin/hgcommit-prefixes.vim')
    source $HOME/.vim/ftplugin/hgcommit-prefixes.vim
endif

let hgrclist = readfile(getcwd() . '/.hg/hgrc')
let url = Strip(split(hgrclist[1], '=')[1])
if has_key(g:commit_prefixes, url)
    call append(line(0), g:commit_prefixes[url])
endif
