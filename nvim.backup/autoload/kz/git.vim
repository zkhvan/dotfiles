" ============================================================================
" Git helpers
" ============================================================================

" Get git root
"
" @param {string} [path] to run in
" @return {string} git root
function! kz#git#GetRoot(...) abort
  let l:path = a:0 && type(a:1) == type('') ? a:1 : ''
  let l:cmd = 'git rev-parse --show-toplevel 2>/dev/null'
  let l:result = split(
        \ ( empty(l:path)
        \   ? system(l:cmd)
        \   : system('cd -- "' . l:path . '" && ' . l:cmd)
        \ ), '\n')
  if v:shell_error | return '' | endif
  return len(l:result) ? l:result[0] : ''
endfunction

" Get git branch
"
" @param {string} [path] to run in
" @return {string} current branch name
function! kz#git#GetBranch(...) abort
  let l:path = a:0 && type(a:1) == type('') ? a:1 : ''
  let l:cmd = 'git rev-parse --abbrev-ref HEAD 2>/dev/null'
  let l:result = split(
        \ ( empty(l:path)
        \   ? system(l:cmd)
        \   : system('cd -- "' . l:path . '" && ' . l:cmd)
        \ ), '\n')
  if v:shell_error | return '' | endif
  return len(l:result) ? l:result[0] : ''
endfunction
