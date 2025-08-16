" plugin/plug-mkdnflow.vim
"
augroup kzmkdnflow
  autocmd!
augroup END

if !kzplug#IsLoaded('mkdnflow.nvim') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

lua << EOF
require('mkdnflow').setup({
  bib = {
    default_path = 'index.bib',
    find_in_root = true
  },
  perspective = {
    priority = 'root',
    fallback = 'current',
    root_tell = 'index.md'
  },
  links = {
    transform_explicit = function(text)
      text = text:gsub(" ", "-")
      text = text:lower()
      text = os.date('%Y-%m-%d-')..text
      return(text)
    end
  },
  mappings = {
    MkdnNewListItem = {'i', '<CR>'},
  }
})
EOF

let &cpoptions = s:cpo_save
unlet s:cpo_save
