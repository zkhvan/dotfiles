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
let g:kz_fzf_float = 0

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

" ----------------------------------------------------------------------------
" Plugins: autoinstall vim-plug, define plugins, install plugins if needed
" ----------------------------------------------------------------------------

if g:kz_autoinstall_vim_plug
  let s:has_plug = !empty(glob(expand(g:kz#vim_dir . '/autoload/plug.vim')))
  " Load vim-plug and its plugins?
  if !s:has_plug && executable('curl')
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
" Autocommands
" ============================================================================

augroup kzwindow
  autocmd!
  autocmd VimResized * wincmd =
augroup END

augroup kzlines
  autocmd!
  if kzplug#IsLoaded('coc.nvim')
    autocmd User CocNvimInit ++nested call kzline#Init()
  else
    autocmd VimEnter * ++nested call kzline#Init()
  endif
augroup END

" augroup kzproject
"   autocmd!
"   autocmd BufNewFile,BufRead,BufWritePost * call kz#project#MarkBuffer()
"   autocmd User CocNvimInit call kz#lint#SetupCoc()
"   autocmd User neomake call kz#lint#Setup()
" augroup END

" Auto-reload the colorscheme if it was edited in vim
augroup kzcoloredit
  autocmd!
  autocmd BufWritePost */colors/*.vim so <afile>
augroup END

augroup kzhelm
  autocmd!
  autocmd BufRead,BufNewFile */template/*.yaml set ft=helm
augroup END

" Read only mode (un)mappings
augroup kzreadonly
  autocmd!
  autocmd BufEnter * call kz#readonly#Unmap()
augroup END

" Disable linting and syntax highlighting for large and minified files
augroup kzhugefile
  autocmd BufReadPre *
        \   if getfsize(expand("%")) > 10000000
        \|    syntax off
        \|    let b:kz_hugefile = 1
        \|  endif
  autocmd BufReadPre *.min.* syntax off
augroup END

" Automatically assign file marks for filetype when switch buffer so you can
" easily go between e.g., css/html using `C `H
" https://old.reddit.com/r/vim/comments/df4jac/how_do_you_use_marks/f317a1l/
augroup kzautomark
  autocmd!
  autocmd BufLeave *.css,*.less,*.scss  normal! mC
  autocmd BufLeave *.html               normal! mH
  autocmd BufLeave *.js*,*.ts*          normal! mJ
  autocmd BufLeave *.md                 normal! mM
  autocmd BufLeave *.yml,*.yaml         normal! mY
augroup END

augroup kzrestoreposition
  autocmd!
  autocmd BufWinEnter * call kz#RestorePosition()
augroup END

augroup kzxmlfolding
  autocmd!
  autocmd FileType xml let g:xml_syntax_folding=1
  autocmd FileType xml setlocal foldmethod=syntax
augroup END

" ============================================================================
" Security
" ============================================================================

" Disallow unsafe local vimrc commands
" Leave down here since it trims local settings
set secure

" =============================================================================

" vim: sw=2 :
