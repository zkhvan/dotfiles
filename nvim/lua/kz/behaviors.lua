-- ===========================================================================
-- Change vim behavior via autocommands
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

local groups = {}
local augroup = function(name, opts)
  if not groups[name] then
    opts = opts or {}
    groups[name] = vim.api.nvim_create_augroup(name, opts)
  end
  return groups[name]
end
local autocmd = vim.api.nvim_create_autocmd

-- ---------------------------------------------------------------------------

autocmd('VimResized', {
  desc = 'Automatically resize windows when resizing Vim',
  command = 'tabdo wincmd =',
  group = augroup('kzwindow'),
})

autocmd('QuitPre', {
  desc = 'Auto close corresponding loclist when quitting a window',
  command = [[ if &filetype != 'qf' | silent! lclose | endif ]],
  nested = true,
  group = augroup('kzwindow'),
})

autocmd('BufWinEnter', {
  desc = 'Restore last cursor position when opening file',
  callback = 'kz#RestorePosition',
  group = augroup('kzrestoreposition'),
})

autocmd('VimEnter', {
  desc = 'Initialize statusline on VimEnter',
  nested = true,
  callback = 'kzline#Init',
  group = augroup('kzstatusline'),
})

autocmd({ 'BufNewFile', 'BufRead', 'BufWritePost' }, {
  desc = 'Set kz#project variables on buffers',
  callback = 'kz#project#MarkBuffer',
  group = augroup('kzproject'),
})

autocmd('BufWritePost', {
  desc = 'Auto-reload the colorscheme if it was edited in vim',
  pattern = '*/colors/*.vim',
  command = 'source <afile>',
  group = augroup('kzcoloredit'),
})

autocmd('BufEnter', {
  desc = 'Read only mode (un)mappings',
  callback = 'kz#readonly#Unmap',
  group = augroup('kzreadonly'),
})

autocmd('BufReadPre', {
  desc = 'Disable linting and syntax highlighting for large and minified files',
  command = [[
    if getfsize(expand("%")) > 10000000
      syntax off
      let b:kz_hugefile = 1
    endif
  ]],
  group = augroup('kzhugefile'),
})

autocmd('BufReadPre', {
  desc = 'Disable syntax on minified files',
  pattern = '*.min.*',
  command = 'syntax off',
  group = augroup('kzhugefile'),
})

autocmd('FileType', {
  desc = 'Automatic folding for xml files',
  pattern = 'xml',
  command = [[
    let g:xml_syntax_folding=1
    setlocal foldmethod=syntax
  ]],
  group = augroup('kzxmlfolding'),
})

autocmd('TextYankPost', {
  desc = 'Highlight yanked text after yanking',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 150,
      on_visual = true,
    })
  end,
  group = augroup('kzediting'),
})

autocmd({ 'BufWritePre', 'FileWritePre' }, {
  desc = 'Create missing parent directories on write',
  callback = function(args)
    local dir = vim.fs.dirname(args.file)
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end
  end,
  group = augroup('kzautomkdir'),
})

autocmd('LspAttach', {
  desc = 'Bind LSP in buffer',
  callback = function(args)
    --[[
    {
      buf = 1,
      data = {
        client_id = 1
      },
      event = "LspAttach",
      file = "/Users/zkhvan/.dotfiles/nvim/lua/kz/behaviors.lua",
      id = 20,
      match = "/Users/zkhvan/.dotfiles/nvim/lua/kz/behaviors.lua"
    }
    --]]

    local bufnr = args.buf

    -- First LSP attached
    if not vim.b.has_lsp then
      vim.b.has_lsp = true
      require("kz.mappings").bind_lsp(bufnr)
    end
  end,
  group = augroup('kzlsp')
})
