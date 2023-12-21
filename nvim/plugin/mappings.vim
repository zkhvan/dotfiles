" plugin/mappings.vim
scriptencoding utf-8

" KEEP IDEMPOTENT
" There is no loaded guard on top, so any recursive maps need a silent unmap
" prior to binding. This way this file can be edited and sourced at any time
" to rebind keys.

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================
" Disable for reuse
" ============================================================================

" [n]gs normally waits for [n] seconds, totally useless
noremap   gs    <NOP>

" ============================================================================
" Commands
" ============================================================================

" Remap Q as q
" https://vi.stackexchange.com/questions/7859/workaround-for-q-to-q-while-quitting-in-vim
command! Q q

" Closest
nnoremap  <silent><special>  <Leader>ecr
      \ :<C-U>call kz#edit#EditClosest('README.md')<CR>

" Notes
nnoremap  <silent><special>  <Leader>ent
      \ :<C-U>execute 'edit ' . expand($HOME) . '/Google\ Drive/Notes/TODO.md'<CR>
nnoremap  <silent><special>  <Leader>ens
      \ :<C-U>execute 'edit ' . expand($HOME) . '/Google\ Drive/Notes/Scratchpad'<CR>
nnoremap  <silent><special>  <Leader>enn
      \ :<C-U>execute 'edit ' . expand($HOME) . '/Google\ Drive/Notes/' . strftime('%Y-%m-%d') . '.md'<CR>

" Dotfiles
nnoremap  <silent><special>  <Leader>evp
      \ :<C-U>execute 'edit ' . g:vdotdir . '/autoload/kzplug/plugins.vim'<CR>
nnoremap  <silent><special>  <Leader>evm
      \ :<C-U>execute 'edit ' . g:vdotdir . '/plugin/mappings.vim'<CR>
nnoremap  <silent><special>  <Leader>ega
      \ :<C-U>execute 'edit ' . expand($DOTFILES) . '/git/aliases.gitconfig'<CR>

" ============================================================================
" Buffer manip
" ============================================================================

" Close buffer without destroying window
nnoremap  <silent><special>  <Leader>x
      \ :<C-U>lclose<CR>:bp\|bd #<CR>

" Prev buffer with <BS> backspace in normal (C-^ is kinda awkward)
nnoremap  <special>   <BS>  <C-^>

" ============================================================================
" Window manipulation
" ============================================================================

" ----------------------------------------------------------------------------
" Resize (can take a count, eg. 2<S-Left>)
" ----------------------------------------------------------------------------

nnoremap  <special>   <S-Up>      <C-W>+
nnoremap  <special>   <S-Down>    <C-W>-
nnoremap  <special>   <S-Left>    <C-w><
nnoremap  <special>   <S-Right>   <C-w>>

silent! iunmap <S-Up>
silent! iunmap <S-Down>
silent! iunmap <S-Left>
silent! iunmap <S-Right>
imap      <special>   <S-Up>      <C-o><S-Up>
imap      <special>   <S-Down>    <C-o><S-Down>
imap      <special>   <S-Left>    <C-o><S-Left>
imap      <special>   <S-Right>   <C-o><S-Right>

nnoremap <C-W><C-V>f :exec "vert norm <C-V><C-W>f"<CR>
nnoremap <C-W><C-V>] :exec "vert norm <C-V><C-W>]"<CR>

" ----------------------------------------------------------------------------
" Move windows with <A-*> to match terminal keybinds
" ----------------------------------------------------------------------------

nnoremap <special> <A-Up>     <C-w>k
nnoremap <special> <A-Down>   <C-w>j
nnoremap <special> <A-Left>   <C-w>h
nnoremap <special> <A-Right>  <C-w>l

" ============================================================================
" Mode and env
" ============================================================================

" ----------------------------------------------------------------------------
" cd to current buffer's git root
" ----------------------------------------------------------------------------

nnoremap <silent><special>   <Leader>cr
      \ :<C-U>execute 'cd! ' . kz#project#GetRoot()<CR>

" ----------------------------------------------------------------------------
" cd to current buffer path
" ----------------------------------------------------------------------------

nnoremap <silent><special>   <Leader>cd
      \ :<C-U>cd! %:h<CR>

" ----------------------------------------------------------------------------
" go up a level
" ----------------------------------------------------------------------------

nnoremap <silent><special>   <Leader>..
      \ :<C-U>cd! ..<CR>

" ============================================================================
" Helper methods for diff
" ============================================================================

nnoremap  <special>   <Leader>d0  :<C-U>let buf=bufnr('%') \| exec 'bufdo diffoff' \| exec 'b' buf<CR>
nnoremap  <special>   <Leader>d1  :<C-U>windo diffthis<CR>
nnoremap  <special>   <Leader>d2  :<C-U>windo diffupdate<CR>

" ============================================================================
" Editing
" ============================================================================

" ----------------------------------------------------------------------------
" Quickly apply macro q
" ----------------------------------------------------------------------------

nnoremap  <special> <Leader>q   @q

" ----------------------------------------------------------------------------
" Map the arrow keys to be based on display lines, not physical lines
" ----------------------------------------------------------------------------

vnoremap  <special>   <Down>      gj
vnoremap  <special>   <Up>        gk

" ----------------------------------------------------------------------------
" Start/EOL
" ----------------------------------------------------------------------------

" Easier to type, and I never use the default behavior.
noremap   H   ^
noremap   L   g_

" ----------------------------------------------------------------------------
" Reselect visual block after indent
" ----------------------------------------------------------------------------

xnoremap  <   <gv
xnoremap  >   >gv

" ----------------------------------------------------------------------------
" <Tab> indents in visual mode (recursive map to the above)
" ----------------------------------------------------------------------------

silent! vunmap <Tab>
silent! vunmap <S-Tab>
vmap <special> <Tab>     >
vmap <special> <S-Tab>   <

" ----------------------------------------------------------------------------
" Sort lines (use unix sort)
" ----------------------------------------------------------------------------

" Auto select paragraph (bounded by blank lines) and sort
nnoremap  <special> <Leader>s   vip:!sort<CR>

" Sort selection (no clear since in visual)
xnoremap  <special> <Leader>s   :!sort<CR>

" ----------------------------------------------------------------------------
" Clean up whitespace
" ----------------------------------------------------------------------------

nnoremap  <special> <Leader>ws  :<C-U>call kz#whitespace#clean()<CR>

" ----------------------------------------------------------------------------
" Don't jump on first * -- simpler vim-asterisk
" https://stackoverflow.com/questions/4256697/vim-search-and-highlight-but-do-not-jump#comment91750564_4257175
" ----------------------------------------------------------------------------

" nnoremap            *           m`:<C-U>keepjumps normal! *``<CR>
nnoremap  <silent>  *           :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>

" ----------------------------------------------------------------------------
" Runners
" ----------------------------------------------------------------------------

nnoremap  <Leader>Rn   :%!node -p<CR>
vnoremap  <Leader>Rn   :!node -p<CR>
vnoremap  <Leader>RN   :w !node -p \| pbcopy<CR><CR>

" ============================================================================
" Visual
" ============================================================================

" ----------------------------------------------------------------------------
" Close window with <C-Esc> mapped to <F13>
" ----------------------------------------------------------------------------

nnoremap  <special> <F13>       :q<CR>

" ----------------------------------------------------------------------------
" Unfuck my screen
" ----------------------------------------------------------------------------

nnoremap <silent> U :<C-U>:diffupdate<CR>
                    \ :syntax sync fromstart<CR><C-L>
                    \ :<C-U>:set cmdheight=1<CR>

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
