" autoload/kz/edit.vim

" ============================================================================
" Quick edit
" ec* - Edit closest (find upwards)
" er* - Edit from kz#project#GetRoot()
" ============================================================================

" @param {String} file
function! kz#edit#Edit(file) abort
  if empty(a:file)
    echomsg 'File not found: ' . a:file
    return
  endif
  execute 'edit ' . a:file
endfunction

" This executes instead of returns string so the mapping can noop when file
" not found.
" @param {String} file
function! kz#edit#EditClosest(file) abort
  let l:file = findfile(a:file, '.;')
  call kz#edit#Edit(l:file)
endfunction

" As above, this noops if file not found
" @param {String} file
function! kz#edit#EditRoot(file) abort
  let l:file = kz#project#GetFile(a:file)
  call kz#edit#Edit(l:file)
endfunction
