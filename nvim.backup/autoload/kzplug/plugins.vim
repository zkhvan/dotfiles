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
  " Not needed
  Plug 'antoinemadec/FixCursorHold.nvim', PlugIf(!has('nvim-0.8'))

  " ==========================================================================
  " Vim debugging
  " ==========================================================================

  " Show slow plugins
  " Haven't used this
  Plug 'tweekmonster/startuptime.vim', { 'on': [ 'StartupTime' ] }

  " `:Bufferize messages` to get messages (or any :command) in a new buffer
  " Done
  let g:bufferize_command = 'tabnew'
  Plug 'AndrewRadev/bufferize.vim', { 'on': [ 'Bufferize' ] }

  " ==========================================================================
  " Tree Sitter
  " ==========================================================================

  " Done
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  " TODO?
  Plug 'nvim-treesitter/playground'

  " ==========================================================================
  " Colorscheme
  " ==========================================================================

  " Don't need
  Plug 'mhartington/oceanic-next'

  " Done
  if isdirectory(g:kz#vim_dir . '/mine/vim-colors-meh')
    Plug g:kz#vim_dir . '/mine/vim-colors-meh'
  else
    Plug 'davidosomething/vim-colors-meh'
  endif

  " ==========================================================================
  " Embedded filetype support
  " ==========================================================================

  " tyru/caw.vim, some others use this to determine inline embedded filetypes
  " Do I still need after having treesitter?
  Plug 'Shougo/context_filetype.vim'

  " ==========================================================================
  " Commands
  " ==========================================================================

  " Use the repo instead of the version in brew since it includes the help
  " docs for fzf#run()
  " Done
  Plug 'junegunn/fzf', PlugIf(g:kz_use_fzf)

  " No config, see if I need
  let g:fzf_command_prefix = 'FZF'
  let g:fzf_layout = extend({ 'down': '~40%' }, g:kz_fzf_float
        \   ? { 'window': 'call kz#float#Bordered()' }
        \   : {}
        \ )
  let g:fzf_buffers_jump = 1
  " Done
  Plug 'junegunn/fzf.vim', PlugIf(g:kz_use_fzf)

  " Done
  let g:git_messenger_max_popup_width = 70
  let g:git_messenger_max_popup_height = 24
  Plug 'rhysd/git-messenger.vim', PlugIf(exists('*nvim_win_set_config'))

  " Swap windows without ruining layout
  " <Leader>ww on both windows to swap them
  " Not doing, this is too slow to use normally
  Plug 'wesQ3/vim-windowswap'

  " Add file manip commands like Remove, Move, Rename, SudoWrite
  " Do not lazy load, tracks buffers
  " I don't use this
  Plug 'tpope/vim-eunuch'

  " <C-w>o to zoom in/out of a window
  "Plug 'dhruvasagar/vim-zoom'
  " Better zoom plugin, accounts for command window and doesn't use sessions
  " Done
  Plug 'troydm/zoomwintab.vim'

  " ==========================================================================
  " Navigation
  " ==========================================================================

  " Try switching away from chadtree
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
  " Done
  let g:matchup_delim_noskips = 2
  let g:matchup_matchparen_deferred = 1
  let g:matchup_matchparen_status_offscreen = 0
  Plug 'andymass/vim-matchup', PlugIf(has('patch-7.4.1689'))

  " add gS on char to smart split lines at char, like comma lists and html tags
  " Don't use this?
  let g:splitjoin_trailing_comma = 0
  let g:splitjoin_ruby_trailing_comma = 1
  let g:splitjoin_ruby_hanging_args = 1
  Plug 'AndrewRadev/splitjoin.vim'

  " ==========================================================================
  " Editing keys
  " ==========================================================================

  " filetype custom [[ and ]] jumping
  " Don't think I use this
  Plug 'arp242/jumpy.vim'

  " Don't use?
  Plug 'svermeulen/vim-yoink'

  " Research new options
  Plug 'godlygeek/tabular', { 'on': [ 'Tabularize' ] }
  Plug 'junegunn/vim-easy-align', { 'on': [ 'EasyAlign' ] }

  " Haven't used
  Plug 'bootleq/vim-cycle', { 'on': [ '<Plug>Cycle' ] }

  Plug 'tpope/vim-repeat'

  " []-bindings -- buffer switch, lnext/prev, etc.
  " Fork has a lot of removals like line movement and entities
  Plug 'davidosomething/vim-unimpaired'

  " used for line bubbling commands (instead of unimpared!)
  Plug 'matze/vim-move'

  Plug 'kana/vim-operator-user'
  " gcc to toggle comment, not supporting treesitter...
  " Plug 'tyru/caw.vim', { 'on': [ '<Plug>(caw' ] }
  Plug 'numToStr/Comment.nvim'
  Plug 'JoosepAlviste/nvim-ts-context-commentstring'
  " gs(a/r/d) to modify surrounding the pending operator
  Plug 'rhysd/vim-operator-surround', { 'on': [ '<Plug>(operator-surround' ] }
  " <Leader>c to toggle PascalCase/snak_e the pending operator
  Plug 'tyru/operator-camelize.vim', { 'on': [ '<Plug>(operator-camelize' ] }

  " Some textobjs are lazy loaded since they are ~4ms slow to load.
  " See plugin/textobj.vim to see how they're mapped.
  " -       Base textobj plugin
  Plug 'kana/vim-textobj-user'
  " - i     for indent level
  Plug 'kana/vim-textobj-indent', { 'on': [ '<Plug>(textobj-indent' ] }
  " - P     for last paste
  Plug 'gilligan/textobj-lastpaste', { 'on': [ '<Plug>(textobj-lastpaste' ] }
  " - u     for url
  Plug 'mattn/vim-textobj-url', { 'on': [ '<Plug>(textobj-url' ] }
  " - b     for any block type (parens, braces, quotes, ltgt)
  Plug 'rhysd/vim-textobj-anyblock'
  " - h     for markdown headers
  " - f     for markdown code blocks
  " - m     for markdown text blocks
  Plug 'coachshea/vim-textobj-markdown'

  " HR with <Leader>f[CHAR]
  Plug g:kz#vim_dir . '/mine/vim-hr'

  " ==========================================================================
  " Completion
  " ==========================================================================

  " --------------------------------------------------------------------------
  " Snippet engine
  " Now using coc-snippets
  " --------------------------------------------------------------------------

  " Provides some ultisnips snippets for use with neosnippet or coc-snippets
  Plug 'honza/vim-snippets', WithCompl()

  " --------------------------------------------------------------------------
  " Completion engine
  " --------------------------------------------------------------------------

  " https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
  let g:coc_global_extensions = [
        \  '@yaegassy/coc-tailwindcss3',
        \  '@yaegassy/coc-ansible',
        \  'coc-calc',
        \  'coc-css',
        \  'coc-diagnostic',
        \  'coc-docthis',
        \  'coc-eslint',
        \  'coc-git',
        \  'coc-go',
        \  'coc-html',
        \  'coc-json',
        \  'coc-markdownlint',
        \  'coc-prettier',
        \  'coc-snippets',
        \  'coc-sumneko-lua',
        \  'coc-tsserver',
        \  'coc-vimlsp',
        \  'coc-xml',
        \  'coc-yaml',
        \]
  Plug 'neoclide/coc.nvim', WithCompl({ 'branch': 'master', 'do': 'yarn install --frozen-lockfile' })

  " ==========================================================================
  " Language: ansible config
  " ==========================================================================

  " ft specific stuff only
  Plug 'pearofducks/ansible-vim'

  " ==========================================================================
  " Language: bash/shell/zsh
  " ==========================================================================

  Plug 'chrisbra/vim-sh-indent'
  Plug 'chrisbra/vim-zsh'

  " ==========================================================================
  " Language: Git
  " ==========================================================================

  " creates gitconfig, gitcommit, rebase
  " provides :DiffGitCached in gitcommit file type
  " vim 7.4-77 ships with 2013 version, this is newer
  Plug 'tpope/vim-git'

  " Show commit contents during rebase
  Plug 'hotwatermorning/auto-git-diff'

  " show diff when editing a COMMIT_EDITMSG
  let g:committia_open_only_vim_starting = 0
  let g:committia_use_singlecolumn       = 'always'
  Plug 'rhysd/committia.vim'

  " Provides nice tree diff/merge view
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'sindrets/diffview.nvim'

  " ==========================================================================
  " Language: JavaScript and derivatives, JSON
  " ==========================================================================

  Plug 'neoclide/jsonc.vim'

  " TypeScript
  Plug 'HerringtonDarkholme/yats.vim'

  " ----------------------------------------
  " Syntax
  " ----------------------------------------

  " Common settings for vim-javascript, vim-jsx-improve
  " let g:javascript_plugin_flow = 0
  let g:javascript_plugin_jsdoc = 1

  Plug 'pangloss/vim-javascript'

  " ----------------------------------
  " JSX
  " ----------------------------------

  " Offers inline code highlighting in JSX blocks, as well as vim-jsx's hi
  Plug 'maxmellon/vim-jsx-pretty'

  " ==========================================================================
  " Language: Jupyter
  " ==========================================================================
  Plug 'goerz/jupytext.vim'

  " ==========================================================================
  " Language: Helm
  " ==========================================================================
  Plug 'towolf/vim-helm'

  " ==========================================================================
  " Language: Markdown, Pandoc
  " ==========================================================================

  " Override vim included markdown ft* and syntax
  " The git repo has a newer syntax file than the one that ships with vim
  " I'm using jumpy.vim for [[ and ]]
  let g:no_markdown_maps = 1
  Plug 'tpope/vim-markdown'

  " after/syntax for GitHub emoji, checkboxes
  Plug 'rhysd/vim-gfm-syntax'

  " Plug 'jakewvincent/mkdnflow.nvim'
  Plug 'mickael-menu/zk-nvim'

  Plug 'ferrine/md-img-paste.vim'

  Plug 'dhruvasagar/vim-table-mode'

  " ==========================================================================
  " Language: Powershell
  " ==========================================================================

  Plug 'PProvost/vim-ps1'

  " ==========================================================================
  " Debugging
  " ==========================================================================

  Plug 'puremourning/vimspector'
  Plug 'vim-test/vim-test'
  Plug 'preservim/vimux'

  " ==========================================================================
  " UI -- load last!
  " ==========================================================================

  Plug 'delphinus/vim-auto-cursorline', PlugIf(exists('*timer_start'))

  Plug 'nathanaelkane/vim-indent-guides'

  Plug 'osyo-manga/vim-over', { 'on': [ 'OverCommandLine' ] }

  " --------------------------------------------------------------------------
  " Quickfix window
  " --------------------------------------------------------------------------

  Plug 'blueyed/vim-qf_resize'

  Plug 'romainl/vim-qf'

  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

  " --------------------------------------------------------------------------
  " Window events
  " --------------------------------------------------------------------------

  Plug 'wellle/visual-split.vim', { 'on': [
        \   'VSResize', 'VSSplit',
        \   'VSSplitAbove', 'VSSplitBelow',
        \   '<Plug>(Visual-Split',
        \ ] }

endfunction
