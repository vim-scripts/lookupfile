" lookupfile.vim: Lookup filenames by pattern
" Author: Hari Krishna (hari_vim at yahoo dot com)
" Last Change: 05-Jul-2006 @ 12:00
" Created:     11-May-2006
" Requires:    Vim-7.0, genutils.vim(1.2)
" Version:     1.1.1
" Licence: This program is free software; you can redistribute it and/or
"          modify it under the terms of the GNU General Public License.
"          See http://www.gnu.org/copyleft/gpl.txt 
" Download From:
"     http://www.vim.org//script.php?script_id=1581
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

if !exists('g:LookupFile_TagExpr')
  " Default tag expression.
  let g:LookupFile_TagExpr = '&tags'
endif

if !exists('g:LookupFile_LookupFunc')
  " An alternate user function to lookup matches.
  let g:LookupFile_LookupFunc = ''
endif

if !exists('g:LookupFile_LookupNotifyFunc')
  " The function that should be notified when a file is selected.
  let g:LookupFile_LookupNotifyFunc = ''
endif

if !exists('g:LookupFile_MinPatLength')
  " Min. length of the pattern to trigger lookup.
  let g:LookupFile_MinPatLength = 4
endif

if !exists('g:LookupFile_PreservePatternHistory')
  " Show the past patterns also in the buffers.
  let g:LookupFile_PreservePatternHistory = 1
endif

if !exists('g:LookupFile_PreserveLastPattern')
  " Start with the last pattern when a new lookup is started.
  let g:LookupFile_PreserveLastPattern = 1
endif

if !exists('g:LookupFile_ShowFiller')
  " Show "Looking up files.." while the tags are being looked up.
  let g:LookupFile_ShowFiller = 1
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

command! LUPath :call <SID>LookupUsing(s:SNR().'LookupPath')
command! LUBuf :call <SID>LookupUsing(s:SNR().'LookupBuf')
command! LUArgs :call <SID>LookupUsing(s:SNR().'LookupArgs')

let s:mySNR = ''
function s:SNR()
  if s:mySNR == ''
    let s:mySNR = matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSNR$')
  endif
  return s:mySNR
endfun

function! s:LookupUsing(func)
  unlet! s:SavedLookupFunc s:SavedLookupNotifyFunc
  let s:SavedLookupFunc = g:LookupFile_LookupFunc
  let s:SavedLookupNotifyFunc = g:LookupFile_LookupNotifyFunc
  unlet g:LookupFile_LookupFunc g:LookupFile_LookupNotifyFunc
  let g:LookupFile_LookupFunc = function(a:func)
  let g:LookupFile_LookupNotifyFunc = function(s:SNR().'LookupReset')
  LookupFile
endfunction

function! s:LookupReset()
  if exists('s:SavedLookupFunc')
    unlet g:LookupFile_LookupFunc g:LookupFile_LookupNotifyFunc
    let g:LookupFile_LookupFunc = s:SavedLookupFunc
    let g:LookupFile_LookupNotifyFunc = s:SavedLookupNotifyFunc
  endif
endfunction

function! s:LookupPath(pattern)
  let files = globpath(&path, '*'.a:pattern.'*')
  return split(files, "\<NL>")
endfunction

function! s:LookupBuf(pattern)
  let results = []
  let i = 1
  while i <= bufnr('$')
    if bufexists(i) && fnamemodify(bufname(i), ':p:t') =~ a:pattern
      call add(results, bufname(i))
    endif
    let i = i + 1
  endwhile
  return results
endfunction

function! s:LookupArgs(pattern)
  return filter(argv(), 'v:val =~ a:pattern')
endfunction

" Restore cpo.
let &cpo = s:save_cpo
unlet s:save_cpo

" vim6:fdm=marker et sw=2
