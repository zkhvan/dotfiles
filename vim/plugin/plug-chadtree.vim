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
      \   'keymap.toggle_version_control': [','],
      \   'options.polling_rate': 2.0,
      \   'options.version_control.enable': v:false,
      \   'options.close_on_open': v:true,
      \   'view.width': 60,
      \ }

let &cpoptions = s:cpo_save
unlet s:cpo_save
