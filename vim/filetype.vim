" filetype.vim
"
" This needs to be first -- don't move into after/ or else some manually
" defined ftplugins won't load
"
" These do NOT get overridden -- see *ftdetect* in vim filetype help
" http://vimdoc.sourceforge.net/htmldoc/filetype.html
"
" Runs on `filetype on`
"

if exists('g:kz_filetypes_loaded') | finish | endif
let g:kz_filetypes_loaded = 1

" For files that might be JSON or YAML, read first line and use that
function! s:SetJSONorYAML() abort
  if getline(1) ==# '{'
    setfiletype json
    return
  endif
  setfiletype yaml
endfunction

function! s:SetByShebang() abort
  let l:shebang = getline(1)
  if l:shebang =~# '^#!.*/.*\s\+node\>' | setfiletype javascript | endif
  if l:shebang =~# '^#!.*/.*\s\+zsh\>' | setfiletype zsh | endif
endfunction

" For filetypes that can be detected by filename (option C in the docs for
" `new-filetype`)
" Use `autocmd!` so the original filetype autocmd for the given extension gets
" cleared (otherwise it will run, and then this one, possible causing two
" filetype events to execute in succession)
augroup filetypedetect
  " pangloss/vim-javascript provides this
  autocmd! BufNewFile,BufRead * call s:SetByShebang()

  autocmd! BufNewFile,BufRead *.dump setfiletype sql
  autocmd! BufNewFile,BufRead .flake8 setfiletype dosini

  autocmd! BufNewFile,BufRead *.gitconfig setfiletype gitconfig

  " git branch description (opened via `git branch --edit-description`)
  autocmd! BufNewFile,BufRead BRANCH_DESCRIPTION
        \ setfiletype gitbranchdescription.markdown

  " marko templating, close enough to HTML
  autocmd! BufNewFile,BufRead *.marko setfiletype html.marko
  autocmd! BufNewFile,BufRead *.template setfiletype html

  autocmd! BufNewFile,BufRead .babelrc,.bowerrc,.jshintrc setfiletype json

  autocmd! BufNewFile,BufRead jsconfig.json,tsconfig.json setfiletype jsonc

  autocmd! BufNewFile,BufRead .eslintrc,.stylelintrc call s:SetJSONorYAML()

  autocmd! BufNewFile,BufRead */nginx*.conf,/*/nginx*.conf setfiletype nginx

  autocmd! BufNewFile,BufRead *.plist setfiletype xml

  " ironic that it doesn't use a .yml/.yaml extension
  autocmd! BufNewFile,BufRead .yamllint setfiletype yaml
augroup END
