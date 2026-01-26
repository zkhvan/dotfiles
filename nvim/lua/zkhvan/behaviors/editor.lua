local zkautocmd = require('zkhvan.utils.autocmd')

local augroup = zkautocmd.augroup
local aucmd = zkautocmd.aucmd

aucmd('BufWritePre', {
  desc = 'Create missing parent directories on write',
  callback = function(event)
    if event.match:match('^%w%w+:[\\/][\\/]') then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
  group = augroup('zkhvan.automkdir'),
})
