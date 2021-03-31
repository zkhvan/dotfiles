" autoload/kzplug/plugins.vim

" Similar but safer than Cond() from
" <https://github.com/junegunn/vim-plug/wiki/faq>
" This is a global function for command access
function! PlugIf(condition, ...) abort
  let l:enabled = a:condition ? {} : { 'on': [], 'for': [] }
  return a:0 ? extend(l:enabled, a:000[0]) : l:enabled
endfunction

" Shortcut
function! WithCompl(...) abort
  return call('PlugIf', [ g:kz_use_completion ] + a:000)
endfunction

function! kzplug#plugins#LoadAll() abort
  " Notes on adding plugins:
  " - Absolutely do not use 'for' if the plugin provides an `ftdetect/`

  " ==========================================================================
  " Fixes
  " ==========================================================================

  " Fix CursorHold
  " https://github.com/neovim/neovim/issues/12587
  Plug 'antoinemadec/FixCursorHold.nvim', PlugIf(has('nvim'))

  " ==========================================================================
  " Vim debugging
  " ==========================================================================

  " Show slow plugins
  Plug 'tweekmonster/startuptime.vim', { 'on': [ 'StartupTime' ] }

  " `:Bufferize messages` to get messages (or any :command) in a new buffer
  let g:bufferize_command = 'tabnew'
  Plug 'AndrewRadev/bufferize.vim', { 'on': [ 'Bufferize' ] }

  " Required by Inspecthi, don't lazy
  Plug 'cocopon/colorswatch.vim'

  silent! nunmap zs
  nnoremap <silent> zs :<C-U>Inspecthi<CR>
  Plug 'cocopon/inspecthi.vim', { 'on': [ 'Inspecthi' ] }

  " ==========================================================================
  " Colorscheme
  " ==========================================================================

  Plug 'mhartington/oceanic-next'
  Plug 'davidosomething/vim-colors-meh'

  " ==========================================================================
  " Embedded filetype support
  " ==========================================================================

  " tyru/caw.vim, some others use this to determine inline embedded filetypes
  Plug 'Shougo/context_filetype.vim'

  " ==========================================================================
  " Commands
  " ==========================================================================

  " Use the repo instead of the version in brew since it includes the help
  " docs for fzf#run()
  Plug 'junegunn/fzf', PlugIf(g:kz_use_fzf)

  let g:fzf_command_prefix = 'FZF'
  let g:fzf_layout = extend({ 'down': '~40%' }, g:kz_fzf_float
        \   ? { 'window': 'call kz#float#Bordered()' }
        \   : {}
        \ )
  let g:fzf_buffers_jump = 1
  Plug 'junegunn/fzf.vim', PlugIf(g:kz_use_fzf)

  let g:git_messenger_max_popup_width = 70
  let g:git_messenger_max_popup_height = 24
  Plug 'rhysd/git-messenger.vim', PlugIf(exists('*nvim_win_set_config'))

  " Add file manip commands like Remove, Move, Rename, SudoWrite
  " Do not lazy load, tracks buffers
  Plug 'tpope/vim-eunuch'

  " <C-w>o to zoom in/out of a window
  "Plug 'dhruvasagar/vim-zoom'
  " Better zoom plugin, accounts for command window and doesn't use sessions
  Plug 'troydm/zoomwintab.vim'

  " ==========================================================================
  " Navigation
  " ==========================================================================

  Plug 'ms-jpq/chadtree', { 'branch': 'chad', 'do': 'python3 -m chadtree deps', 'on': [ 'CHADopen' ] }

  " ==========================================================================
  " Input, syntax, spacing
  " ==========================================================================

  " match-up is a plugin that lets you highlight, navigate, and operate on
  " sets of matching text. It extends vim's % key to language-specific words
  " instead of just single characters.
  "
  " minimum supported vim version: 7.4.1689
  " https://github.com/andymass/vim-matchup/issues/4
  let g:matchup_delim_noskips = 2
  let g:matchup_matchparen_deferred = 1
  let g:matchup_matchparen_status_offscreen = 0
  Plug 'andymass/vim-matchup', PlugIf(has('patch-7.4.1689'))

  " add gS on char to smart split lines at char, like comma lists and html tags
  let g:splitjoin_trailing_comma = 0
  let g:splitjoin_ruby_trailing_comma = 1
  let g:splitjoin_ruby_hanging_args = 1
  Plug 'AndrewRadev/splitjoin.vim'

  " ==========================================================================
  " Editing keys
  " ==========================================================================

  " filetype custom [[ and ]] jumping
  Plug 'arp242/jumpy.vim'

  Plug 'svermeulen/vim-yoink', PlugIf(has('nvim'))

  Plug 'bootleq/vim-cycle', { 'on': [ '<Plug>Cycle' ] }

  " used for line bubbling commands (instead of unimpared!)
  Plug 'matze/vim-move'

  " HR with <Leader>f[CHAR]
  Plug g:kz#vim_dir . '/mine/vim-hr'

  " ==========================================================================
  " Visual
  " ==========================================================================

  Plug 'nathanaelkane/vim-indent-guides'

  Plug 'osyo-manga/vim-over', { 'on': [ 'OverCommandLine' ] }

endfunction
