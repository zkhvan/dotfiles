" plugin/colorscheme.vim

let s:truecolor = has('termguicolors')
      \ && $COLORTERM ==# 'truecolor'
      \ && $TERM_PROGRAM !=# 'Apple_Terminal'

if s:truecolor | let &termguicolors = 1 | endif

augroup kzcolorscheme
  autocmd! VimEnter * nested silent! execute 'colorscheme meh'
augroup END
