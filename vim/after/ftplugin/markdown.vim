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

  nnoremap  <silent><buffer><special>  <Leader>mp
        \ :<C-U>MarkdownPreview<CR>

  nnoremap  <silent><buffer><special>  <Leader>mn
        \ :<C-U>exec printf('silent !open %s/%s', 'http://localhost:8201', expand('%'))<CR>

  let &cpoptions = s:cpo_save
  unlet s:cpo_save
endif
