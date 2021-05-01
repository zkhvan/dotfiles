" after/ftplugin/markdown.vim
"
setlocal nomodeline
setlocal spell

" Override pandoc
setlocal textwidth=78
" the line will be right after column 80, &tw+3
setlocal colorcolumn=+3

if exists('$ITERM_PROFILE') || has('gui_macvim')
  let s:cpo_save = &cpoptions
  set cpoptions&vim

  nnoremap  <silent><buffer><special>  <Leader>m
        \ :<C-U>MarkdownPreview<CR>

  let &cpoptions = s:cpo_save
  unlet s:cpo_save
endif
