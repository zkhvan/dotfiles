" plugin/plug-md-img-paste.vim
"
augroup kzmdip
  autocmd!
augroup END

if !kzplug#IsLoaded('md-img-paste.vim') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

autocmd kzmdip FileType markdown
      \ nmap <buffer><silent>     <Leader>p
      \   :<C-U>call mdip#MarkdownClipboardImage()<CR>

let &cpoptions = s:cpo_save
unlet s:cpo_save
