" after/plugin/fzf.vim

augroup kzfzf
  autocmd!
augroup END

if !kzplug#IsLoaded('fzf.vim') | finish | endif

autocmd kzfzf FileType fzf set laststatus=0 noshowmode noruler
      \| autocmd kzfzf BufLeave <buffer> set laststatus=2 showmode ruler

" ============================================================================
" Local Helpers
" ============================================================================

" fzf#run() can't use autoload function in options so wrap it with
" a script-local
"
" @return {String} project root
function! s:GetRoot() abort
  return kz#project#GetRoot()
endfunction

" @return {String} tests dir
function! s:GetTests() abort
  return kz#project#GetDir('tests')
endfunction

" ============================================================================
" Custom sources for junegunn/fzf
" ============================================================================

" Notes:
" - Use fzf#wrap() instead of 'sink' option to get the <C-T/V/X> keybindings
"   when the source is to open files

" Some default options.
" --cycle through list
" --multi select with <Tab>
let s:options = ' --tiebreak=end --cycle --multi '

function s:WithLayout(opts) abort
  return extend(copy(a:opts), g:fzf_layout)
endfunction

" ----------------------------------------------------------------------------
" My vim runtime files
" ----------------------------------------------------------------------------

" @return {List} my files in my vim runtime
function! s:GetFzfVimSource() abort
  " Want these recomputed every time in case files are added/removed
  let l:runtime_dirs_files = globpath(g:kz#vim_dir, '{' . join([
        \   'after',
        \   'autoload',
        \   'colors',
        \   'ftplugin',
        \   'lua',
        \   'mine',
        \   'plugin',
        \   'snippets',
        \   'syntax',
        \ ], ',') . '}/**/*.{lua,vim}', 0, 1)
  let l:runtime_files = globpath(g:kz#vim_dir, '*.{lua,vim}', 0, 1)
  let l:rcfiles = globpath(g:kz#vim_dir, '*init.vim', 0, 1)
  return l:runtime_dirs_files + l:runtime_files + l:rcfiles
endfunction

command! FZFVim
      \ call fzf#run(fzf#wrap('Vim',
      \   fzf#vim#with_preview(s:WithLayout({
      \     'dir':      s:GetRoot(),
      \     'source':   s:GetFzfVimSource(),
      \     'options':  s:options . ' --prompt="Vim> "',
      \   }), 'right:50%')
      \ ))

" ============================================================================
" Custom commands for fzf.vim
" ============================================================================

" ----------------------------------------------------------------------------
" FZFGrepper
" fzf.vim ripgrep or ag with preview
" Fallback to git-grep if rg and ag not installed (e.g. I'm ssh'ed somewhere)
" https://github.com/junegunn/fzf.vim#advanced-customization
" ----------------------------------------------------------------------------

" FZFGrepper! settings
let s:grepper_full = fzf#vim#with_preview(
      \   { 'dir': s:GetRoot() },
      \   'up:60%'
      \ )

" FZFGrepper settings
let s:grepper_half = fzf#vim#with_preview(
      \   { 'dir': s:GetRoot() },
      \   'right:50%',
      \   '?'
      \ )

if kz#grepper#Get().command ==# 'rg'
  command! -bang -nargs=* FZFGrepper
        \ call fzf#vim#grep(
        \   'rg --color=always --column --line-number --no-heading '
        \     . '--hidden --smart-case '
        \     . '--no-ignore-vcs '
        \     . '--ignore-file "${DOTFILES}/ignore/dot.ignore" '
        \     . shellescape(<q-args>),
        \   1,
        \   <bang>0 ? s:grepper_full : s:grepper_half,
        \   <bang>0
        \ )
elseif kz#grepper#Get().command ==# 'ag'
  " https://github.com/junegunn/fzf.vim/blob/abdf894edf5dbbe8eaa734a6a4dce39c9f174e33/autoload/fzf/vim.vim#L614
  " Default options are --nogroup --column --color
  let s:ag_options = ' --skip-vcs-ignores --smart-case '

  command! -bang -nargs=* FZFGrepper
        \ call fzf#vim#ag(
        \   <q-args>,
        \   s:ag_options,
        \   <bang>0 ? s:grepper_full : s:grepper_half,
        \   <bang>0
        \ )
else
  command! -bang -nargs=* FZFGrepper
        \ call fzf#vim#grep(
        \   'git grep --line-number ' . shellescape(<q-args>),
        \   1,
        \   <bang>0 ? s:grepper_full : s:grepper_half,
        \   <bang>0
        \ )
endif

" ----------------------------------------------------------------------------
" Files from project root
" ----------------------------------------------------------------------------

" FZFProject! settings
let s:project_full = fzf#vim#with_preview(
      \   {},
      \   'up:60%'
      \ )

" FZFProject settings
let s:project_half = fzf#vim#with_preview(
      \   {},
      \   'right:50%',
      \   '?'
      \ )

command! -bang FZFProject
      \ call fzf#vim#files(
      \   s:GetRoot(),
      \   <bang>0 ? s:project_full : s:project_half,
      \   <bang>0
      \ )

" ============================================================================
" Mappings
" ============================================================================

let s:cpo_save = &cpoptions
set cpoptions&vim

" Map the commands -- the actual plugin is loaded by a vim-plug 'on' hook when
" a command is run for the first time

" Bind all navigation commands to <Leader>g prefix
" nnoremap  <silent><special>   <Leader>gb   :<C-U>FZFBuffers<CR>
" nnoremap  <silent><special>   <Leader>gc   :<C-U>FZFCommands<CR>
" nnoremap  <silent><special>   <Leader>gf   :<C-U>FZFFiles<CR>
" nnoremap  <silent><special>   <Leader>gF   :<C-U>FZFGFiles<CR>
" nnoremap  <silent><special>   <Leader>gg   :<C-U>FZFGrepper!<CR>
" nnoremap  <silent><special>   <Leader>gp   :<C-U>FZFProject<CR>
" nnoremap  <silent><special>   <Leader>gv   :<C-U>FZFVim<CR>

let &cpoptions = s:cpo_save
unlet s:cpo_save
