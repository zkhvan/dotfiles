-- ===========================================================================
-- Change vim behavior via autocommands
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

local augroup = function(name, opts)
  opts = opts or {}
  return vim.api.nvim_create_augroup(name, opts)
end
local autocmd = vim.api.nvim_create_autocmd

-- ---------------------------------------------------------------------------

local windowGroup = augroup('kzwindow')
autocmd('VimResized', {
  desc = 'Automatically resize windows when resizing Vim',
  command = 'tabdo wincmd =',
  group = windowGroup,
})

autocmd('QuitPre', {
  desc = 'Auto close corresponding loclist when quitting a window',
  command = [[ if &filetype != 'qf' | silent! lclose | endif ]],
  nested = true,
  group = windowGroup,
})

local restorePositionGroup = augroup('kzrestoreposition')
autocmd('BufWinEnter', {
  desc = 'Restore last cursor position when opening file',
  callback = 'kz#RestorePosition',
  group = restorePositionGroup,
})

local statusLineGroup = augroup('kzstatusline')
if vim.fn['kzplug#IsLoaded']('coc.nvim') == 1 then
  autocmd('User', {
    pattern = 'CocNvimInit',
    desc = 'Initialize statusline after coc has started',
    nested = true,
    callback = 'kzline#Init',
    group = statusLineGroup,
  })
else
  autocmd('VimEnter', {
    desc = 'Initialize statusline on VimEnter',
    nested = true,
    callback = 'kzline#Init',
    group = statusLineGroup,
  })
end

local projectGroup = augroup('kzproject')
autocmd({ 'BufNewFile', 'BufRead', 'BufWritePost' }, {
  desc = 'Set kz#project variables on buffers',
  callback = 'kz#project#MarkBuffer',
  group = projectGroup,
})

local colorEditGroup = augroup('kzcoloredit')
autocmd('BufWritePost', {
  desc = 'Auto-reload the colorscheme if it was edited in vim',
  pattern = '*/colors/*.vim',
  command = 'source <afile>',
  group = colorEditGroup,
})

local readonlyGroup = augroup('kzreadonly')
autocmd('BufEnter', {
  desc = 'Read only mode (un)mappings',
  callback = 'kz#readonly#Unmap',
  group = readonlyGroup,
})

local hugefileGroup = augroup('kzhugefile')
autocmd('BufReadPre', {
  desc = 'Disable linting and syntax highlighting for large and minified files',
  command = [[
    if getfsize(expand("%")) > 10000000
      syntax off
      let b:kz_hugefile = 1
    endif
  ]],
  group = hugefileGroup,
})

autocmd('BufReadPre', {
  desc = 'Disable syntax on minified files',
  pattern = '*.min.*',
  command = 'syntax off',
  group = hugefileGroup,
})

local helmGroup = augroup('kzhelm')
autocmd({ 'BufRead', 'BufNewFile' }, {
  desc = 'Set helm files inside template directories',
  pattern = '*/template/*.yaml',
  command = 'set ft=helm',
  group = helmGroup,
})

local xmlfoldingGroup = augroup('kzxmlfolding')
autocmd('FileType', {
  desc = 'Automatic folding for xml files',
  pattern = 'xml',
  command = [[
    let g:xml_syntax_folding=1
    setlocal foldmethod=syntax
  ]],
  group = xmlfoldingGroup,
})
