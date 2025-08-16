" plugin/plug-vimspector.vim

if !kzplug#Exists('vimspector') | finish | endif

augroup kzvimspector
  autocmd!
augroup END

let s:cpo_save = &cpoptions
set cpoptions&vim

let g:vimspector_base_dir = g:vdotdir . '/vimspector'

let g:vimspector_enable_mappings = 'HUMAN'

let g:vimspector_install_gadgets = ['delve']

" for normal mode - the word under the cursor
nmap <Leader>di <Plug>VimspectorBalloonEval
" for visual mode, the visually selected text
xmap <Leader>di <Plug>VimspectorBalloonEval

nmap <Leader>dq :call vimspector#Reset()<CR>

let &cpoptions = s:cpo_save
unlet s:cpo_save
