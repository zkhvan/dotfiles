" autoload/kzline.vim
scriptencoding utf-8

function! kzline#GetTabline() abort
  let l:view = kzline#GetView(winnr())

  let l:contents = '%#StatusLine#'

  " ==========================================================================
  " Left side
  " ==========================================================================

  " Search context
  let l:lastpat = @/
  let l:contents .= kzline#Format(
        \ empty(l:lastpat) ? '' : ' ' . l:lastpat . ' ',
        \ '%#kzStatusKey# ? %(%#Search#',
        \ '%)')

  " ==========================================================================
  " Right side
  " ==========================================================================

  " Leave 24 chars for search
  let l:maxwidth = float2nr(&columns) - 24
  let l:maxwidth = l:maxwidth > 0 ? l:maxwidth : 0
  let l:contents .= '%#StatusLine# %= '

  if kzplug#IsLoaded('coc.nvim')
    let l:contents .= kzline#Format(
          \ kzline#CocStatus(l:view),
          \ '%(%#kzStatusValue#',
          \ ' %)'
          \)
  endif

  let l:contents .= kzline#Format(
        \ ' ' . get(l:view, 'cwd', '~') . ' ',
        \ '%#kzStatusKey# ʟᴄᴅ %(%#kzStatusValue#%<',
        \ '%)')

  let l:contents .= !empty(get(g:, 'coc_git_status', ''))
        \ ? '%#kzStatusKey# ' . g:coc_git_status . ' '
        \ : kzline#Format(
        \     kzline#GitBranch(l:view),
        \     '%#kzStatusKey# ∆ %(%#kzStatusValue#',
        \     '%)'
        \   )

  " ==========================================================================

  return l:contents
endfunction

function! kzline#GetStatusline(winnr) abort
  if empty(a:winnr) || a:winnr > winnr('$')
    return
  endif
  let l:view = kzline#GetView(a:winnr)

  let l:contents = ''

  " ==========================================================================
  " Left side
  " ==========================================================================

  let l:contents .= kzline#Mode(l:view.winnr)

  " Restore color to ensure parts aren't hidden on inactive buffers
  let l:contents .= '%#StatusLine#'

  " Filebased
  let l:contents .= kzline#Format(
        \ kzline#Filetype(l:view.ft),
        \ kzline#ActiveColor(l:view, '%#kzStatusKey#'))

  " Parent dir and filename
  let l:contents .= kzline#Format(
        \ kzline#TailDirFilename(l:view),
        \ kzline#ActiveColor(l:view, '%#StatusLine#'))
  let l:contents .= kzline#Format(
        \ kzline#Dirty(l:view.bufnr),
        \ kzline#ActiveColor(l:view, '%#DiffAdded#'))

  " Toggleable
  let l:contents .= kzline#Format(
        \ kzline#Paste(),
        \ kzline#ActiveColor(l:view, '%#DiffText#'))

  let l:contents .= kzline#Format(
        \ kzline#Readonly(l:view.bufnr),
        \ kzline#ActiveColor(l:view, '%#kzLineImportant#'))

  " ==========================================================================
  " Right side
  " ==========================================================================

  let l:contents .= '%*%='

  " Linting
  if kzplug#IsLoaded('coc.nvim')
    let l:contents .= kzline#CocDiagnostics(l:view)
  endif
  if kzplug#IsLoaded('neomake') && exists('*neomake#GetJobs')
    let l:contents .= kzline#Neomake(l:view)
  endif

  let l:contents .= kzline#Format(
        \ kzline#Ruler(),
        \ kzline#ActiveColor(l:view, '%#kzStatusItem#'))

  return l:contents
endfunction

" ============================================================================
" Output functions
" ============================================================================

" Display an atom if not empty with prefix/suffix
"
" @param {String} content
" @param {String} [before]
" @param {String} [after]
" @return {String}
function! kzline#Format(...) abort
  let l:content = get(a:, 1, '')
  let l:before = get(a:, 2, '')
  let l:after = get(a:, 3, '')
  return empty(l:content) ? '' : l:before . l:content . l:after
endfunction

function! kzline#ActiveColor(view, color) abort
  return a:view.winnr == winnr() ? a:color : '%#StatusLineNC#'
endfunction

" @param {Number} winnr
" @return {String}
function! kzline#Mode(winnr) abort
  " blacklist
  let l:modecolor = '%#StatusLineNC#'

  let l:modeflag = mode()
  if a:winnr != winnr()
    let l:modeflag = ' '
  elseif l:modeflag ==# 'c'
    let l:modecolor = '%#DiffDelete#'
  elseif l:modeflag ==# 'i'
    let l:modecolor = '%#kzStatusItem#'
  elseif l:modeflag ==# 'R'
    let l:modecolor = '%#kzLineModeReplace#'
  elseif l:modeflag =~? 'v'
    let l:modecolor = '%#Cursor#'
  elseif l:modeflag ==? "\<C-v>"
    let l:modecolor = '%#Cursor#'
    let l:modeflag = 'B'
  endif
  return  l:modecolor . ' ' . l:modeflag . ' '
endfunction

" @return {String}
function! kzline#Paste() abort
  return empty(&paste)
        \ ? ''
        \ : ' ᴘ '
endfunction


" @param {Int} bufnr
" @return {String}
function! kzline#Readonly(bufnr) abort
  return getbufvar(a:bufnr, '&readonly') ? ' ʀ ' : ''
endfunction

" @param {String} ft
" @return {String}
function! kzline#Filetype(ft) abort
  return empty(a:ft) ? '' : ' ' . a:ft . ' '
endfunction

" Show buffer's filename and immediate parent directory
"
" @param {Dict} view
" @return {String}
function! kzline#TailDirFilename(view) abort
  if kz#IsNonFile(a:view.bufnr)
    return ''
  endif

  if empty(a:view.bufname)
    return ' ᴜɴɴᴀᴍᴇᴅ '
  endif

  if kz#IsHelp(a:view.bufnr)
    return ' ' . a:view.bufname . ' '
  endif

  let l:parent0 = fnamemodify(a:view.bufname, ':p:h:t')
  let l:parent1 = fnamemodify(a:view.bufname, ':p:h:h:t')
  let l:parent2 = fnamemodify(a:view.bufname, ':p:h:h:h:t')
  let l:filename = fnamemodify(a:view.bufname, ':t')
  return ' ' . substitute(
        \   join([ l:parent2, l:parent1, l:parent0, l:filename ], '/'),
        \   '//', '', 'g'
        \ ) . ' '
endfunction

" @param {Int} bufnr
" @return {String}
function! kzline#Dirty(bufnr) abort
  return getbufvar(a:bufnr, '&modified') ? ' + ' : ''
endfunction

" Get the git branch for the file in buffer
"
" @param {Dict} view
" @return {String}
function! kzline#GitBranch(view) abort
  return kz#IsNonFile(a:view.bufnr)
        \ || empty(getbufvar(a:view.bufnr, 'kz_branch'))
        \ ? ''
        \ : ' ' . getbufvar(a:view.bufnr, 'kz_branch') . ' '
endfunction

" @param {Dict} view
" @return {String}
function! kzline#CocDiagnostics(view) abort
  if kz#IsNonFile(a:view.bufnr) | return '' | endif
  let l:d = getbufvar(a:view.bufnr, 'coc_diagnostic_info')
  return empty(l:d) ? '' :
        \ kzline#Format(
        \   !l:d.error ? '' : ' ⚑' . l:d.error . ' ',
        \   '%(%#kzStatusError#', '%)') .
        \ kzline#Format(
        \   !l:d.warning ? '' : ' ⚑' . l:d.warning . ' ',
        \   '%(%#kzStatusWarning#', '%)') .
        \ kzline#Format(
        \   !l:d.information ? '' : ' ⚑' . l:d.information . ' ',
        \   '%(%#kzStatusInfo#', '%)') .
        \ kzline#Format(
        \   !l:d.hint ? '' : ' ⚑' . l:d.hint . ' ',
        \   '%(%#kzStatusItem#', '%)')
endfunction

function! kzline#CocStatus(view) abort
  return get(g:, 'coc_status', '')
endfunction

" @return {string} job1,job2,job3
function! kzline#NeomakeJobs(bufnr) abort
  if !a:bufnr | return '' | endif
  let l:running_jobs = filter(copy(neomake#GetJobs()),
        \ 'v:val.bufnr == ' . a:bufnr . ' && !get(v:val, "canceled", 0)')
  if empty(l:running_jobs) | return | endif

  return join(map(l:running_jobs, 'v:val.name'), ',')
endfunction

" @param {Dict} view
" @return {String}
function! kzline#Neomake(view) abort
  let l:result = neomake#statusline#get(a:view.bufnr, {
        \   'format_running':         '%#kzLineNeomakeRunning# ᴍ:'
        \                             . kzline#NeomakeJobs(a:view.bufnr) . ' ',
        \   'format_loclist_ok':      '%#kzStatusGood# ✓ ',
        \   'format_loclist_unknown': '',
        \   'format_loclist_type_E':  '%#kzStatusError# ⚑{{count}} ',
        \   'format_loclist_type_W':  '%#kzStatusWarning# ⚑{{count}} ',
        \   'format_loclist_type_I':  '%#kzStatusInfo# ⚑{{count}} ',
        \ })
  return l:result
endfunction

" @return {String}
function! kzline#Ruler() abort
  return ' %5.(%c%) '
endfunction

" ============================================================================
" Utility
" ============================================================================

" Get cached properties for a window. Cleared on status line refresh
"
" @param {Int} winnr
" @return {Dict} properties derived from the active window
function! kzline#GetView(winnr) abort
  let l:cached_view = get(s:view_cache, a:winnr, {})
  if !empty(l:cached_view)
    return l:cached_view
  endif
  let l:bufnr = winbufnr(a:winnr)
  let l:bufname = bufname(l:bufnr)
  let l:cwd = getcwd(a:winnr)
  let l:ft = getbufvar(l:bufnr, '&filetype')
  let l:ww = winwidth(a:winnr)
  let s:view_cache[a:winnr] = {
        \   'winnr': a:winnr,
        \   'bufnr': l:bufnr,
        \   'bufname': l:bufname,
        \   'cwd': l:cwd,
        \   'ft': l:ft,
        \   'ww':  l:ww,
        \ }
  return s:view_cache[a:winnr]
endfunction

function! kzline#Init() abort
  call kzline#SetStatus(winnr())

  call kzline#RefreshTabline()
  set showtabline=2

  silent! nunmap <special> <Plug>(kzline-refresh-tabline)
  nmap <silent><special>
        \ <Plug>(kzline-refresh-tabline)
        \ :call kzline#RefreshTabline()<CR>

  " BufWinEnter will initialize the statusline for each buffer
  let l:refresh_hooks = [
        \   'BufDelete *',
        \   'BufWinEnter *',
        \   'BufWritePost *',
        \   'BufEnter *',
        \   'FileType *',
        \   'WinEnter *',
        \   'User CocDiagnosticChange',
        \   'User NeomakeCountsChanged',
        \   'User NeomakeFinished',
        \ ]
        " \   'SessionLoadPost',
        " \   'TabEnter',
        " \   'VimResized',
        " \   'FileWritePost',
        " \   'FileReadPost',
  call add(l:refresh_hooks, 'DirChanged *')

  let l:tab_refresh_hooks = [
        \   'User CocStatusChange',
        \ ]
  call add(l:tab_refresh_hooks, 'DirChanged *')

  augroup kzline
    autocmd!
    for l:hook in l:tab_refresh_hooks
      execute 'autocmd ' . l:hook . ' call kzline#RefreshTabline()'
    endfor
    for l:hook in l:refresh_hooks
      execute 'autocmd ' . l:hook . ' call kzline#SetStatus(winnr())'
    endfor
  augroup END
endfunction

function! kzline#SetStatus(winnr) abort
  let s:view_cache = {}
  exec 'setlocal statusline=%!kzline#GetStatusline(' . a:winnr . ')'
endfunction

function! kzline#RefreshTabline() abort
  set tabline=%!kzline#GetTabline()
endfunction

" bound to <F11> - see ../plugin/mappings.vim
function! kzline#ToggleTabline() abort
  let &showtabline = &showtabline ? 0 : 2
endfunction
