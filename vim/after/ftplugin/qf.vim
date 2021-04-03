" after/ftplugin/qf.vim

if exists('b:did_after_ftplugin') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================

" Don't include quickfix buffers when cycling
setlocal nobuflisted

" Quit with q
nnoremap  <buffer>    Q   q

" Open result in new tab
nnoremap  <buffer>    t   <C-w><CR><C-w>T

if kzplug#Exists('vim-qf')
  nmap <buffer> { <Plug>(qf_previous_file)
  nmap <buffer> } <Plug>(qf_next_file)
endif

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
