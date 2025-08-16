" ============================================================================
" KZ Project
"
" Helpers to finds config files for a project (e.g. linting RC files) relative
" to a git repo root.
"
" Similar to what this plugin does, but using a single system call to `git`
" instead of using `expand()` with `:h` to traverse up directories.
" https://github.com/dbakker/vim-projectroot/blob/master/autoload/projectroot.vim
"
" Settings:
" b:kz_project_roots [array] - look for config files in this array of
"                              directory names relative to the project
"                              root if it is set
" g:kz_project_roots [array] - global overrides
" ============================================================================

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================
" Default Settings
" ============================================================================

" Look for project config files in these paths
let s:default_roots = [
      \   '',
      \ ]

" Look for project root using these file markers if not a git project
let s:markers = [
      \   'Gemfile',
      \   'composer.json',
      \   'package.json',
      \   'requirements.txt',
      \   'tsconfig.json',
      \ ]

" @param {mixed} { bufnr } or number/string bufnr
" @return {Number|String| bufnr
function! s:BufnrFromArgs(...) abort
  if a:0
    return type(a:1) == type(0) || type(a:1) == type('')
          \ ? a:1
          \ : type(a:1) == type({}) && a:1['bufnr']
          \ ? a:1['bufnr']
          \ : '%'
  endif
  return '%'
endfunction

" Mark buffer -- set up buffer local variables or update a buffer's meta data
function! kz#project#MarkBuffer(...) abort
  let l:bufnr = s:BufnrFromArgs(a:000)
  call kz#project#SetRoot('')      " clear
  call kz#project#GetRoot(l:bufnr) " force reset
  call setbufvar(l:bufnr, 'kz_branch', kz#git#GetBranch(expand('%:p:h')))
endfunction

" ============================================================================
" Project root resolution
" ============================================================================

" Buffer-cached project root, prefer based on file markers
"
" @param {String} [file] from which to look upwards
" @return {String} project root path or empty string
function! kz#project#GetRoot(...) abort
  let l:bufnr = s:BufnrFromArgs(a:000)
  if empty(getbufvar(l:bufnr, 'kz_project_root', ''))
    let l:existing = getbufvar(l:bufnr, 'kz_project_root')
    if !empty(l:existing) | return l:existing | endif

    " Look for markers FIRST, that way we support things like browsing through
    " node_modules/ and monorepos
    let l:root = kz#project#GetRootByFileMarker(s:markers)

    " Try git root
    let l:path = kz#project#GetFilePath(get(a:, 1, ''))
    let l:gitroot = kz#project#GetGitRootByFile(l:path)
    if !empty(l:gitroot)
      call setbufvar(l:bufnr, 'kz_project_gitroot', l:gitroot)
      if empty(l:root) | let l:root = l:gitroot | endif
    endif

    call setbufvar(l:bufnr, 'kz_project_root', l:root)
  endif
  return getbufvar(l:bufnr, 'kz_project_root', '')
endfunction

function! kz#project#SetRoot(root) abort
  let b:kz_project_root = a:root
endfunction

" @return {Boolean} if gitroot and project root differ
function! kz#project#IsMonorepo() abort
  if empty(kz#project#GetRoot()) | return 0 | endif
  return b:kz_project_root !=# get(b:, 'kz_project_gitroot', '')
endfunction

" @param {String} file to get path to
" @return {String} path to project root
function! kz#project#GetFilePath(file) abort
  " Argument
  " Path for given file
  let l:path = get(a:, 'file')
        \ ? fnamemodify(resolve(expand(a:file)), ':p:h')
        \ : ''

  " Fallback to current file if no argument
  " Try current file's path
  let l:path = empty(l:path) && filereadable(expand('%'))
        \ ? expand('%:p:h')
        \ : l:path

  " Fallback if no current file
  " File was not readable so just use current path buffer started from
  let l:path = empty(l:path) ? getcwd() : l:path

  " Special circumstances
  " Go up one level if INSIDE the .git/ dir
  let l:path = fnamemodify(l:path, ':t') ==# '.git'
        \ ? fnamemodify(l:path, ':p:h:h')
        \ : l:path

  return l:path
endfunction

" Buffer-cached gitroot
"
" @cached
" @param {String} path
" @return {String} git root of file or empty string
function! kz#project#GetGitRootByFile(path) abort
  if !exists('b:kz_project_gitroot')
    let b:kz_project_gitroot = kz#git#GetRoot(a:path)
  endif
  return b:kz_project_gitroot
endfunction

" @param {String[]} markers
" @return {String} root path based on presence of file marker
function! kz#project#GetRootByFileMarker(markers) abort
  let l:result = ''
  for l:marker in a:markers
    " Try to use nearest first; findfile .; goes from current file upwards
    let l:filepath = findfile(l:marker, '.;')
    if empty(l:filepath) | continue | endif
    let l:result = fnamemodify(resolve(expand(l:filepath)), ':p:h')
  endfor
  return l:result
endfunction

" @cached
" @return {String[]}
function! kz#project#Type() abort
  if !exists('b:kz_project_type')
    let b:kz_project_type = []
    if expand('%:p') =~? 'content/\(mu-plugins\|plugins\|themes\)'
      let b:kz_project_type += 'wordpress'
    endif
  endif
  return b:kz_project_type
endfunction

" Get array of possible config file paths for a project -- any dirs where
" files like .eslintrc, package.json, etc. might be stored. These will be
" paths relative to the root from kz#project#GetRoot
"
" @cached
" @return {String[]} config paths relative to kz#project#GetRoot
function! kz#project#GetPaths() abort
  if !exists('b:kz_project_paths')
    let b:kz_project_paths = get(
          \   b:, 'kz_project_roots', get(
          \   g:, 'kz_project_roots',
          \   s:default_roots
          \ ))
  endif
  return b:kz_project_paths
endfunction

" Get full path to a dir in a project
"
" @param {String} dirname
" @return {String} full path to dir
function! kz#project#GetDir(dirname) abort
  if empty(kz#project#GetRoot()) | return '' | endif

  for l:root in kz#project#GetPaths()
    let l:current =
          \ expand(kz#project#GetRoot() . '/' . l:root)

    if !isdirectory(l:current)
      continue
    endif

    if isdirectory(glob(l:current . a:dirname))
      return l:current . a:dirname
    endif
  endfor

  return ''
endfunction

" Get full path to a file in a project
" Look in local project first, then in git root
"
" @param {String} filename
" @return {String} full path to config file
function! kz#project#GetFile(filename) abort
  if empty(kz#project#GetRoot()) | return '' | endif

  let l:project_root = kz#project#IsMonorepo()
        \ ? get(b:, 'kz_project_gitroot', kz#project#GetRoot())
        \ : kz#project#GetRoot()

  " Try to use nearest first; up to the root
  let l:bounds = expand('%:p:h') . ';' . l:project_root
  let l:nearest = findfile(a:filename, l:bounds)
  if !empty(l:nearest) | return l:nearest | endif

  " @FIXME
  " Look in local paths for the project (not including git root)
  for l:root in kz#project#GetPaths()
    let l:current = empty(l:root)
          \ ? expand(l:project_root)
          \ : expand(l:project_root . '/' . l:root)
    if !isdirectory(l:current) | continue | endif
    if filereadable(glob(l:current . a:filename))
      return l:current . a:filename
    endif
  endfor

  return ''
endfunction

" Get bin local to project
"
" @param {String} bin path relative to project root
" @return {String}
function! kz#project#GetBin(bin) abort
  if empty(a:bin) | return '' | endif

  " Use cached
  let l:bins = kz#InitDict('b:kz_project_bins')
  if !empty(get(l:bins, a:bin)) | return l:bins[a:bin] | endif

  " Use found
  let l:exe = kz#project#GetFile(a:bin)
  if !empty(l:exe) && executable(l:exe)
    let l:bins[a:bin] = l:exe
    return l:exe
  endif

  return ''
endfunction

" Find the first existing file in list of candidate filenames by looking up
" from current path
"
" @FIXME this goes by first found filename in parents
" instead of first found filename closest to the active file's path
function! kz#project#GetCandidate(candidates) abort
  for l:candidate in a:candidates
    let l:attempt = kz#project#GetFile(l:candidate)
    if !empty(l:attempt)
      return l:attempt
    endif
  endfor
  return ''
endfunction

" ============================================================================
" prettier
" Can be run on many different file types, not just JS
" ============================================================================

let s:prettierrc_candidates = [
      \   '.prettierrc',
      \   '.prettierrc.yaml',
      \   '.prettierrc.yml',
      \   '.prettierrc.json',
      \   '.prettierrc.js',
      \   'prettier.config.js',
      \ ]

" @cached
" @return {String} prettierrc filename
function! kz#project#GetPrettierrc() abort
  if !exists('b:kz_project_prettierrc')
    let b:kz_project_prettierrc =
          \ kz#project#GetCandidate(s:prettierrc_candidates)
    if empty(b:kz_project_prettierrc)
      let b:kz_project_prettierrc =
            \ expand('$DOTFILES/prettier/prettier.config.js')
    endif
  endif
  return b:kz_project_prettierrc
endfunction

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
