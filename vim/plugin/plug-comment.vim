" plugin/plug-comment.vim
"
augroup kzcomment
  autocmd!
augroup END

if !kzplug#IsLoaded('Comment.nvim') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

lua << EOF
require('Comment').setup()
EOF

let &cpoptions = s:cpo_save
unlet s:cpo_save
