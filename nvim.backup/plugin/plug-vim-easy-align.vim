" plugin/plug-vim-easy-align.vim
scriptencoding utf-8

" Check for IsPlugged instead of IsLoaded since we lazy load
if !kzplug#Exists('vim-easy-align') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
