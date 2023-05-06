" after/plugin/escesc.vim
"
" Clear things on <Esc><Esc>

let s:cpo_save = &cpoptions
set cpoptions&vim


" ============================================================================

function! g:KZClearUI() abort
  if exists(':GitMessengerClose')
    GitMessengerClose
  endif
  let @/ = ''
  nohlsearch
  redraw!
endfunction

silent!   nunmap              <Esc><Esc>
nnoremap  <silent><special>   <Esc><Esc> :<C-U>call g:KZClearUI()<CR>

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
