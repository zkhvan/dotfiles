" plugin/coc.vim

augroup kzcoc
  autocmd!
augroup END

if !kzplug#IsLoaded('coc.nvim')
  finish
endif

" --------------------------------------------------------------------------
" Settings
" --------------------------------------------------------------------------

let g:coc_enable_locationlist = 0

autocmd kzcoc FileType css,less,scss
      \ let b:coc_additional_keywords = ['-']

" coc-snippets
let g:coc_snippet_next = '' "'<C-f>'
let g:coc_snippet_prev = '' "'<C-b>'

if exists('+tagfunc')
  set tagfunc=CocTagFunc
endif

" --------------------------------------------------------------------------
" Utils
" --------------------------------------------------------------------------

let s:vim_help = ['vim', 'help']
function! s:ShowDocumentation()
  if (index(s:vim_help, &filetype) >= 0)
    execute 'h ' . expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . ' ' . expand('<cword>')
  endif
endfunction

" --------------------------------------------------------------------------
" Mappings
" --------------------------------------------------------------------------

let s:cpo_save = &cpoptions
set cpoptions&vim

inoremap <silent><expr> <C-Space> coc#refresh()

nnoremap <silent> K :<C-U>call <SID>ShowDocumentation()<CR>

" Function textobjs
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Action
nmap <silent> <Leader>c= <Plug>(coc-codeaction)
nmap <silent> <Leader>ca <Plug>(coc-codeaction-cursor)
vmap <silent> <Leader>ca <Plug>(coc-codeaction-selected)

" Diagnostics
nmap <silent> <Leader>d <Plug>(coc-diagnostic-info)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
nmap <silent> [d <Plug>(coc-diagnostic-prev)

" Code navigation
nmap <silent> gh <Plug>(coc-declaration)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> <Leader>t <Plug>(coc-type-definition)
nmap <silent> <Leader>r <Plug>(coc-rename)

" Search workspace symbols.
nmap <silent><nowait> <Leader>gt  :<C-u>CocList -I symbols<cr>

" Formatting
nmap <silent> <Leader>= <Plug>(coc-format-selected)
vmap <silent> <Leader>= <Plug>(coc-format-selected)

nmap <silent> <Leader>bc <Plug>(coc-calc-result-replace)

" coc-git
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)
nnoremap <silent> gsc :<C-U>CocCommand git.showCommit<CR>

" coc-prettier
autocmd kzcoc FileType
      \ javascript,javascriptreact,typescript,typescriptreact,json,graphql
      \ nmap <buffer><silent> <A-=>
      \   :<C-U>CocCommand prettier.formatFile<CR>
      "\   :CocCommand eslint.executeAutofix<CR>

autocmd kzcoc FileType
      \ xml,go
      \ nmap <buffer><silent> <A-=>
      \   <Plug>(coc-format)

" coc-snippets
imap <C-f> <Plug>(coc-snippets-expand-jump)

let &cpoptions = s:cpo_save
unlet s:cpo_save

" --------------------------------------------------------------------------
" Autorun
" --------------------------------------------------------------------------

autocmd kzcoc CursorHold * silent call CocActionAsync('highlight')
