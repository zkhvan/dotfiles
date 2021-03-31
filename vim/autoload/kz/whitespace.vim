" autoload/kz/whitespace.vim

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================

function! kz#whitespace#clean() abort
  " Replace tabs with spaces
  %retab
  let l:save = winsaveview()
  " Turn DOS returns ^M into real returns
  " vint: -ProhibitCommandRelyOnUser -ProhibitCommandWithUnintendedSideEffect
  %s/\r/\r/eg
  %s/\s\+$//e
  call winrestview(l:save)
endfunction

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
