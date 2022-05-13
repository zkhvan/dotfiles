" plugin/plug-vim-test.vim

if !kzplug#Exists('vim-test') | finish | endif

augroup kzvimtest
  autocmd!
augroup END

let s:cpo_save = &cpoptions
set cpoptions&vim

let test#strategy = 'vimux'
let test#go#gotest#options = {
      \ 'nearest': '-v',
      \ 'file': '-v',
      \ 'suite': '-v',
      \ }

nmap <silent> <leader>ur :TestNearest<CR>
nmap <silent> <leader>ud :TestNearest -strategy=delve<CR>
nmap <silent> <leader>uR :TestFile<CR>
nmap <silent> <leader>ua :TestSuite<CR>
nmap <silent> <leader>ul :TestLast<CR>
nmap <silent> <leader>ug :TestVisit<CR>

let &cpoptions = s:cpo_save
unlet s:cpo_save
