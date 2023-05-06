" autoload/kz.vim
"
" init.vim and debugging helper funtions
"

" ============================================================================
" Guards
" ============================================================================

if exists('g:loaded_kz') | finish | endif
let g:loaded_kz = 1

" ============================================================================
" Setup vars
" ============================================================================

let g:kz#vim_dir = fnamemodify(resolve(expand('$MYVIMRC')), ':p:h')

let g:kz#plug_dir = '/vendor/'
let g:kz#plug_absdir = expand('$XDG_DATA_HOME') . '/nvim' . g:kz#plug_dir

" ============================================================================
" General VimL utility functions
" ============================================================================

" @TODO
" @param {String} needle
" @param {String} haystack
" @return {number} 1 true
function! kz#StartsWith(needle, haystack) abort
  return match(a:haystack, '\V' . a:needle)
endfunction

" Output &runtimepath, one per line, to current buffer
function! kz#Runtimepath() abort
  put! =split(&runtimepath, ',', 0)
endfunction

" Declare and define var as new dict if the variable has not been used before
"
" @param  {String} var
" @return {String} the declared var name
function! kz#InitDict(var) abort
  let {a:var} = exists(a:var) ? {a:var} : {}
  return {a:var}
endfunction

" Declare and define var as new list if the variable has not been used before
"
" @param  {String} var
" @return {String} the declared var name
function! kz#InitList(var) abort
  let {a:var} = exists(a:var) ? {a:var} : []
  return {a:var}
endfunction

" Convert to dictionary with keys as filenames
" This will basically uniq() without sorting
"
" @param {List} a
" @param {List} b
" @return {List}
function! kz#Uniq(a, b) abort
  let l:results = {}
  let l:combined = a:a + a:b
  for l:item in l:combined | let l:results[l:item] = 1 | endfor
  return keys(l:results)
endfunction

" @param {List} list
" @return {List} deduplicated list
function! kz#Unique(list) abort
  " stackoverflow style -- immutable, but unnecessary since we're operating on
  " a copy of the list in a:list anyway
  "return filter( copy(l:list), 'index(l:list, v:val, v:key + 1) == -1' )

  " xolox style -- mutable list
  return reverse(filter(reverse(a:list), 'count(a:list, v:val) == 1'))
endfunction

" @param {List} a:000 args
" @return {Mixed} first arg that is non-empty or empty string
function! kz#First(...) abort
  let l:list = type(a:1) == type([]) ? a:1 : a:000
  for l:item in l:list
    if !empty(l:item) | return l:item | endif
  endfor
  return ''
endfunction

function! kz#BorG(var, default) abort
  return get(b:, a:var, get(g:, a:var, a:default))
endfunction

" ============================================================================
" Filepath helpers
" ============================================================================

" Hide CWD in a path (make relative to CWD)
"
" @param {String[]} pathlist to shorten and validate
" @param {String} base to prepend to paths
" @return {String[]} filtered pathlist
function! kz#ShortPaths(pathlist, ...) abort
  let l:pathlist = a:pathlist

  " Prepend base path
  if isdirectory(get(a:, 1, ''))
    call map(l:pathlist, "a:1 . '/' . v:val")
  endif

  " Shorten
  return map(l:pathlist, "fnamemodify(v:val, ':.')" )
endfunction

" Return shortened path
"
" @param {String} path
" @param {Int} max
" @return {String}
function! kz#HomePath(path, ...) abort
  let l:max = get(a:, 1, 0)
  let l:full = fnamemodify(a:path, ':~:.')
  return l:max && len(l:full) > l:max
        \ ? ''
        \ : (len(l:full) == 0 ? '~' : l:full)
endfunction

" ============================================================================
" Factories
" ============================================================================

" Generate a string command to map keys in nvo&ic modes to a command
"
" @param  {Dict}    settings
" @param  {String}  settings.key
" @param  {String}  [settings.command]
" @param  {Int}     [settings.special]
" @param  {Int}     [settings.remap]
" @return {String}  to execute (this way :verb map traces back to correct file)
function! kz#MapAll(settings) abort
  " Auto determine if special key was mapped
  " Just in case I forgot to include cpoptions guards somewhere
  let l:special = get(a:settings, 'special', 0) || a:settings.key[0] ==# '<'
        \ ? '<special>'
        \ : ''

  let l:remap = get(a:settings, 'remap', 1)
        \ ? 'nore'
        \ : ''

  " Key to map
  let l:lhs = '<silent>'
        \ . l:special
        \ . ' ' . a:settings.key . ' '

  " Command to map to
  if !empty(get(a:settings, 'command', ''))
    let l:rhs_nvo = ':<C-U>' . a:settings.command . '<CR>'
    let l:rhs_ic  = '<Esc>' . l:rhs_nvo
  else
    " No command
    " @TODO support non command mappings
    return ''
  endif

  " Compose result
  let l:mapping_nvo = l:remap . 'map '  . l:lhs . ' ' . l:rhs_nvo
  let l:mapping_ic  = l:remap . 'map! ' . l:lhs . ' ' . l:rhs_ic
  return l:mapping_nvo . '| ' . l:mapping_ic
endfunction

" ============================================================================
" Filetype
" ============================================================================

function! kz#IsShebangBash() abort
  return getline(1) =~# '^#!.*bash'
endfunction

" ============================================================================
" Buffer info
" ============================================================================

" @param {Int|String} bufnr or {expr} as in bufname()
" @return {Boolean}
function! kz#IsHelp(bufnr) abort
  return getbufvar(a:bufnr, '&buftype') ==# 'help'
endfunction

let s:nonfilebuftypes = join([
      \ 'help',
      \ 'nofile',
      \ 'quickfix',
      \ 'terminal',
      \], '|')

let s:nonfilefiletypes = join([
      \ 'git$',
      \ 'netrw',
      \ 'vim-plug'
      \], '|')

" @param {Int|String} bufnr or {expr} as in bufname()
" @return {Boolean}
function! kz#IsNonFile(bufnr) abort
  let l:ft = getbufvar(a:bufnr, '&filetype')
  let l:bt = getbufvar(a:bufnr, '&buftype')
  return l:bt =~# '\v(' . s:nonfilebuftypes . ')'
        \ || l:ft =~# '\v(' . s:nonfilefiletypes . ')'
endfunction

" @param {Int|String} bufnr or {expr} as in bufname()
" @return {Boolean}
function! kz#IsEditable(bufnr) abort
  return getbufvar(a:bufnr, '&modifiable')
        \ && !getbufvar(a:bufnr, '&readonly')
        \ && !kz#IsNonFile(a:bufnr)
endfunction

" Usually to see if there's a linter/syntax
"
" @param {Int|String} bufnr
" @return {Boolean}
function! kz#IsTypedFile(...) abort
  let l:bufnr = get(a:, 1, '%')
  return !empty(getbufvar(l:bufnr, '&filetype')) && !kz#IsNonFile(l:bufnr)
endfunction

" ============================================================================
" Restore Position
" From vim help docs on last-position-jump
" ============================================================================

" http://stackoverflow.com/questions/6496778/vim-run-autocmd-on-all-filetypes-except
let s:excluded_ft = [
      \   'gitbranchdescription',
      \   'gitcommit',
      \   'gitrebase',
      \   'hgcommit',
      \   'svn',
      \ ]
function! kz#RestorePosition() abort
  if !kz#IsNonFile('%') || (
        \   index(s:excluded_ft, &filetype) < 0
        \   && line("'\"") > 1 && line("'\"") <= line('$')
        \)

    " Last check for file exists
    " https://github.com/farmergreg/vim-lastplace/blob/48ba343c8c1ca3039224727096aae214f51327d1/plugin/vim-lastplace.vim#L38
    try
      if empty(glob(@%)) | return | endif
    catch | return
    endtry
    silent! normal! g`"
  endif
endfunction

" ============================================================================
" Folding
" ============================================================================

function! kz#FoldExpr() abort
  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()
endfunction

" ============================================================================
" Whitespace settings
" ============================================================================

function! kz#TwoSpace() abort
  setlocal expandtab shiftwidth=2 softtabstop=2
endfunction

function! kz#FourSpace() abort
  setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
endfunction

function! kz#TwoTabs() abort
  setlocal noexpandtab shiftwidth=2 softtabstop=2
endfunction

function! kz#FourTabs() abort
  setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=0
endfunction
