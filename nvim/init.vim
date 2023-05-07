" init.vim
" Neovim init (in place of vimrc)

" ============================================================================
" Settings vars
" ============================================================================

let g:kz_runtimepath_default = &runtimepath

let g:mapleader = "\\"

" Flags
let g:kz_is_iterm = $TERM_PROGRAM ==# 'iTerm.app'

" Plugin settings
let g:kz_autoinstall_vim_plug = executable('git')
let g:kz_use_completion = executable('node')
let g:kz_use_fzf = exists('&autochdir')
let g:kz_fzf_float = 1

" Fallback for vims with no env access
let g:vdotdir = empty($VDOTDIR) ? expand('$XDG_DATA_HOME/nvim') : $VDOTDIR

" ============================================================================
" Settings
" ============================================================================

lua require('providers') -- load providers first
lua require('opt')
lua require('builtin-syntax')
lua require('builtin-plugins')
lua require('terminal')
lua require('behaviors')

" ----------------------------------------------------------------------------
" Plugins: autoinstall vim-plug, define plugins, install plugins if needed
" ----------------------------------------------------------------------------

if g:kz_autoinstall_vim_plug
  let s:has_plug = !empty(glob(expand(g:kz#vim_dir . '/autoload/plug.vim')))
  if !s:has_plug && executable('curl')
  " Load vim-plug and its plugins?
    call kzplug#install#Install()
    let s:has_plug = 1
  endif

  if s:has_plug
    command! PI PlugInstall
    command! PU PlugUpgrade | PlugUpdate
    let g:plug_window = 'tabnew'
    call plug#begin(g:kz#plug_absdir)
    if empty($VIMNOPLUGS) | call kzplug#plugins#LoadAll() | endif
    call plug#end()
  endif
endif

command! -nargs=? WD call kz#write#WriteWithDate(<q-args>)

" ============================================================================
" Security
" ============================================================================

" Disallow unsafe local vimrc commands
" Leave down here since it trims local settings
set secure

" =============================================================================

" vim: sw=2 :
