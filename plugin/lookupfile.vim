" lookupfile.vim: Lookup filenames by pattern
" Author: Hari Krishna (hari_vim at yahoo dot com)
" Last Change: 16-Jun-2006 @ 12:11
" Created:     11-May-2006
" Requires:    Vim-7.0, genutils.vim(1.2)
" Version:     1.0.10
" Licence: This program is free software; you can redistribute it and/or
"          modify it under the terms of the GNU General Public License.
"          See http://www.gnu.org/copyleft/gpl.txt 
" Download From:
"     http://www.vim.org//script.php?script_id=
" Usage:
"     See :help lookupfile.txt

if exists('loaded_lookupfile')
  finish
endif
if v:version < 700
  echomsg 'lookupfile: You need at least Vim 7.0'
  finish
endif
if !exists('loaded_genutils')
  runtime plugin/genutils.vim
endif
if !exists('loaded_genutils') || loaded_genutils < 200
  echomsg 'lookupfile: You need a newer version of genutils.vim plugin'
  finish
endif

let g:loaded_lookupfile = 1

" Make sure line-continuations won't cause any problem. This will be restored
"   at the end
let s:save_cpo = &cpo
set cpo&vim

if !exists('g:lookupfile_TagExpr')
  " Default tag expression.
  let g:lookupfile_TagExpr = '&tags'
endif

if !exists('g:lookupfile_LookupFunc')
  " An alternate user function to lookup matches.
  let g:lookupfile_LookupFunc = ''
endif

if !exists('g:lookupfile_LookupNotifyFunc')
  " The function that should be notified when a file is selected.
  let g:lookupfile_LookupNotifyFunc = ''
endif

if !exists('g:lookupfile_MinPatLength')
  " Min. length of the pattern to trigger lookup.
  let g:lookupfile_MinPatLength = 4
endif

if !exists('g:lookupfile_PreservePatternHistory')
  " Show the past patterns also in the buffers.
  let g:lookupfile_PreservePatternHistory = 1
endif

if !exists('g:lookupfile_PreserveLastPattern')
  " Start with the last pattern when a new lookup is started.
  let g:lookupfile_PreserveLastPattern = 1
endif

if !exists('g:lookupfile_ShowFiller')
  " Show "Looking up files.." while the tags are being looked up.
  let g:lookupfile_ShowFiller = 1
endif

if (! exists("no_plugin_maps") || ! no_plugin_maps) &&
      \ (! exists("no_lookupfile_maps") || ! no_lookupfile_maps)
  noremap <script> <silent> <Plug>LookupFile :LookupFile<CR>

  if !hasmapto('<Plug>LookupFile', 'n')
    nmap <unique> <silent> <F5> <Plug>LookupFile
  endif
  if !hasmapto('<Plug>LookupFile', 'i')
    imap <unique> <silent> <F5> <C-O><Plug>LookupFile
  endif
endif

command! LookupFile :call lookupfile#OpenWindow()

" Restore cpo.
let &cpo = s:save_cpo
unlet s:save_cpo

" vim6:fdm=marker et sw=2
