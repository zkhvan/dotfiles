" plugin/plug-chadtree.vim

if !kzplug#Exists('chadtree') | finish | endif

" ============================================================================
" Mappings
" ============================================================================

let s:cpo_save = &cpoptions
set cpoptions&vim

noremap <Leader>no :CHADopen<CR>
noremap <Leader>nf :CHADopen --always-focus<CR>

let g:chadtree_settings = {
      \   'view.width': 60,
      \ }

let &cpoptions = s:cpo_save
unlet s:cpo_save
