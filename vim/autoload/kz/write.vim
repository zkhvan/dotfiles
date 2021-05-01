" autoload/kz/write.vim

" ============================================================================
" Write helpers
" ============================================================================

" Write the file, prefixed with today's date.
function! kz#write#WriteWithDate(...) abort
  let l:filename = get(a:, 1, '')
  let l:extension = '.' . fnamemodify(l:filename, ':e')
  if len(l:extension) == 1
    let l:extension = '.md'
  endif

  let l:path = escape(
        \ strftime("%Y-%m-%d")
        \ . ( empty(l:filename)
        \   ? l:extension
        \   : '_' . fnamemodify(l:filename, ':r') . l:extension
        \ )
        \ , ' ')

  execute "write " . l:path
endfunction
