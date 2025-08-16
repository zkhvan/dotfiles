" plugin/plug-vim-test.vim

if !kzplug#Exists('vim-test') | finish | endif

augroup kzvimtest
  autocmd!
augroup END

let s:cpo_save = &cpoptions
set cpoptions&vim

function! DelveStrategy(cmd)
  let testName = matchlist(a:cmd, '\v-run ''(.*)\$''')[1]
  call vimspector#LaunchWithSettings( #{ configuration: 'test', TestName: testName } )
endfunction

function! JestStrategy(cmd)
  let testName = matchlist(a:cmd, '\v -t ''(.*)''')[1]
  call vimspector#LaunchWithSettings( #{ configuration: 'jest', TestName: testName } )
endfunction

let g:test#custom_strategies = {
      \ 'delve': function('DelveStrategy'),
      \ 'jest': function('JestStrategy')
      \ }

let test#strategy = 'vimux'
let test#go#gotest#options = {
      \ 'nearest': '-v',
      \ 'file': '-v',
      \ 'suite': '-v',
      \ }

nmap <silent> <leader>ur :TestNearest<CR>
nmap <silent> <leader>uR :TestFile<CR>
nmap <silent> <leader>ua :TestSuite<CR>
nmap <silent> <leader>ul :TestLast<CR>
nmap <silent> <leader>ug :TestVisit<CR>

autocmd kzvimtest FileType
      \ javascript,javascriptreact,typescript,typescriptreact
      \ nmap <buffer><silent> <Leader>ud
      \   :<C-U>TestNearest -strategy=jest<CR>

autocmd kzvimtest FileType
      \ go
      \ nmap <buffer><silent> <Leader>ud
      \   :<C-U>TestNearest -strategy=delve<CR>
" nmap <silent> <leader>ud :TestNearest -strategy=delve<CR>

let &cpoptions = s:cpo_save
unlet s:cpo_save
