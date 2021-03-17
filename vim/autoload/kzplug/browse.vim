" autoload/kzplug/browse.vim

function! kzplug#browse#gx() abort
  let l:line = getline('.')
  let l:sha  = matchstr(l:line, '^  \X*\zs\x\{7,9}\ze ')
  let l:name = empty(l:sha)
        \ ? matchstr(l:line, '^[-x+] \zs[^:]\+\ze:')
        \ : getline(search('^- .*:$', 'bn'))[2:-2]
  let l:name = empty(l:name)
        \ ? substitute(getline('.'), '.*[''"]\(.*/\)\(.*\)[''"].*', '\2', 'g')
        \ : l:name
  let l:uri  = get(get(g:plugs, l:name, {}), 'uri', '')
  if l:uri !~# 'github.com' | return | endif
  let l:repo = matchstr(l:uri, '[^:/]*/' . l:name)
  let l:url  = empty(l:sha)
        \ ? 'https://github.com/' . l:repo
        \ : printf('%s/commit/%s', l:repo, l:sha)
  call system('open "' . l:url . '"')
endfunction
