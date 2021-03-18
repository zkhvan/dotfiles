" init.vim
" Neovim init (in place of vimrc, sources vimrc)

let g:kz_nvim_dir = fnamemodify(resolve(expand('$MYVIMRC')), ':p:h')

" ============================================================================
" GUI editors
" ============================================================================

if exists('g:vv')
  VVset windowheight=100%
  VVset windowwidth=40%
  VVset windowleft=0
  VVset windowtop=0
  VVset fontfamily=JetBrainsMonoNerdFontCompleteM-Regular
  VVset fontsize=12
  VVset lineheight=1.30
endif

" ============================================================================
" Settings
" ============================================================================

set clipboard+=unnamedplus

" Bumped '100 to '1000 to save more previous files
" Bumped <50 to <100 to save more register lines
" Bumped s10 to s100 for to allow up to 100kb of data per item
set shada=!,'1000,<100,s100,h

" The default blinking cursor leaves random artifacts in display like "q" in
" old terminal emulators and some VTEs
" https://github.com/neovim/neovim/issues?utf8=%E2%9C%93&q=is%3Aissue+cursor+shape+q
set guicursor=
augroup kznvim
  autocmd!
  autocmd OptionSet guicursor noautocmd set guicursor=
augroup END

" New neovim feature, it's like vim-over but hides the thing being replaced
" so it is not practical for now (makes it harder to remember what you're
" replacing/reference previous regex tokens). Default is off, but explicitly
" disabled here, too.
" https://github.com/neovim/neovim/pull/5226
set inccommand=

" Pretty quick... errorprone on old vim so only apply to nvim
set updatetime=250

" ============================================================================
" :terminal emulator
" ============================================================================

let g:terminal_scrollback_buffer_size = 100000

" ============================================================================
" Neovim-only mappings
" ============================================================================

" Special key to get back to vim
tnoremap <special> <C-b>      <C-\><C-n>

" Move between windows using Alt-
" Ctrl- works only outside of terminal buffers
tnoremap <special> <A-Up>     <C-\><C-n><C-w>k
tnoremap <special> <A-Down>   <C-\><C-n><C-w>j
tnoremap <special> <A-Left>   <C-\><C-n><C-w>h
tnoremap <special> <A-Right>  <C-\><C-n><C-w>l
nnoremap <special> <A-Up>     <C-w>k
nnoremap <special> <A-Down>   <C-w>j
nnoremap <special> <A-Left>   <C-w>h
nnoremap <special> <A-Right>  <C-w>l
nnoremap <special> <A-k>      <C-w>k
nnoremap <special> <A-j>      <C-w>j
nnoremap <special> <A-h>      <C-w>h
nnoremap <special> <A-l>      <C-w>l

nnoremap <special> <Leader>vt :<C-U>vsplit term://$SHELL<CR>A

" ============================================================================

let g:loaded_ruby_provider = 0
let g:loaded_node_provider = 0

" ============================================================================
" Python setup
" Skips if python is not installed in a pyenv virtualenv
" ============================================================================

function! s:FindExecutable(paths) abort
  for l:path in a:paths
    let l:executable = glob(expand(l:path))
    if executable(l:executable) | return l:executable | endif
  endfor
  return ''
endfunction

" disable python 2
let g:loaded_python_provider = 0

" python 3
let s:pyenv_py3 = s:FindExecutable([
      \   '$PYENV_ROOT/versions/neovim3/bin/python',
      \   '/usr/bin/python3',
      \ ])
if !empty(s:pyenv_py3)
  let g:python3_host_prog = s:pyenv_py3
else
  let g:loaded_python3_provider = !exists('g:fvim_loaded') ? 2 : 0
endif

" =============================================================================

execute 'source ' . g:kz_nvim_dir . '/vimrc'

" vim: sw=2 :
