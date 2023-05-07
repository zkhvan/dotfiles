" plugin/plug-comment.vim
"
augroup kzcomment
  autocmd!
augroup END

if !kzplug#IsLoaded('Comment.nvim') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

lua << EOF
require('Comment').setup({
  mappings = false,
})
EOF

nnoremap <silent> gcc <Plug>(comment_toggle_linewise_current)
xnoremap <silent> gcc <Plug>(comment_toggle_linewise_visual)

let &cpoptions = s:cpo_save
unlet s:cpo_save
