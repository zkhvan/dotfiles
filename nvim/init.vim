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
let g:kz_use_completion = has('nvim-0.3') && executable('node')
let g:kz_use_fzf = v:version >= 704 && exists('&autochdir')
let g:kz_fzf_float = 0 && has('nvim-0.4')

" Fallback for vims with no env access
let g:vdotdir = empty($VDOTDIR) ? expand('$XDG_DATA_HOME/nvim') : $VDOTDIR

" The default blinking cursor leaves random artifacts in display like "q" in
" old terminal emulators and some VTEs
" https://github.com/neovim/neovim/issues?utf8=%E2%9C%93&q=is%3Aissue+cursor+shape+q
set guicursor=
augroup kznvim
  autocmd!
  autocmd OptionSet guicursor noautocmd set guicursor=
augroup END

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
    if !empty(l:executable) && executable(l:executable)
      return l:executable
    endif
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
  let g:loaded_python3_provider = 2
endif


" ============================================================================
" Settings
" ============================================================================

lua require('opt')

" wildignore prevents things from showing up in cmd completion
" It's for things you'd NEVER open in Vim, like caches and binary files
" https://github.com/tpope/vim-fugitive/issues/121#issuecomment-38720847
" https://github.com/kien/ctrlp.vim/issues/63
" https://github.com/tpope/vim-vinegar/issues/61#issuecomment-167432416
" http://tbaggery.com/2011/08/08/effortless-ctags-with-git.html#comment-1396330403
"
" So don't do this! There are cases where you'd edit them or their contents
"set wildignore+=.git
"set wildignore+=.hg,.svn
"set wildignore+=tags
"set wildignore+=*.manifest

" Binary
set wildignore+=*.aux,*.out,*.toc
set wildignore+=*.o,*.obj,*.exe,*.dll,*.jar,*.pyc,*.rbc,*.class
set wildignore+=*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp
set wildignore+=*.avi,*.m4a,*.mp3,*.oga,*.ogg,*.wav,*.webm
set wildignore+=*.eot,*.otf,*.ttf,*.woff
set wildignore+=*.doc,*.pdf
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
" Cache
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*.gem
set wildignore+=.sass-cache
set wildignore+=npm-debug.log
" Compiled
set wildignore+=*.marko.js
set wildignore+=*.min.*,*-min.*
" Temp/System
set wildignore+=*.*~,*~
set wildignore+=*.swp,.lock,.DS_Store,._*,tags.lock

" ----------------------------------------------------------------------------
" Match and search
" ----------------------------------------------------------------------------

if !empty(kz#grepper#Get().command)
  let &g:grepprg = kz#grepper#Get().command . ' '
        \ . join(kz#grepper#Get().options, ' ')
  let &g:grepformat = kz#grepper#Get().format
endif

" ----------------------------------------------------------------------------
" Syntax
" Needs to be in vimrc (or ftdetect) since syntax runs before ftplugin
" ----------------------------------------------------------------------------

" ----------------------------------------
" Filetype: markdown
" ----------------------------------------

" Variable to highlight markdown fenced code properly -- uses tpope's
" vim-markdown plugin (which is bundled with vim7.4 now)
" There are more syntaxes, but checking for them makes editing md very slow
let g:markdown_fenced_languages = [
      \   'javascript', 'js=javascript', 'javascriptreact',
      \   'json',
      \ ]

" ----------------------------------------
" Filetype: sh
" ----------------------------------------

" $VIMRUNTIME/syntax/sh.vim - always assume bash
let g:is_bash = 1

" ----------------------------------------
" Filetype: vim
" ----------------------------------------

" $VIMRUNTIME/syntax/vim.vim
" disable mzscheme, tcl highlighting
let g:vimsyn_embed = 'lpPr'

" ============================================================================
" Security
" ============================================================================

" Disallow unsafe local vimrc commands
" Leave down here since it trims local settings
set secure


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
" Plugins
" ============================================================================

" ----------------------------------------------------------------------------
" Plugins: Disable distributed plugins
" To re-enable you have to comment them out (checks if defined, not if truthy)
" ----------------------------------------------------------------------------

let g:loaded_2html_plugin = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_gzip = 1
let g:loaded_man = 1
let g:loaded_LogiPat = 1
let g:loaded_tarPlugin = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_zipPlugin = 1

" % matching replaced by vim-matchup, which sets the following
"let g:loaded_matchit = 1
" Upstream matchparen -- it is inaccurate. Replaced by vim-matchup
let g:loaded_matchparen = 1

" used to download spellfile and enable gx mapping
"let g:loaded_netrwPlugin = 0

" netrw in details format when no vimfiler
let g:netrw_liststyle      = 3
let g:netrw_home           = expand(g:kz#vim_dir . '/.tmp/cache')
let g:netrw_browsex_viewer = 'kz-open'

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

" =============================================================================
"

" vim: sw=2 :
