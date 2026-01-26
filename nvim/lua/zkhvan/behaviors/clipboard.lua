local zkautocmd = require('zkhvan.utils.autocmd')

local augroup = zkautocmd.augroup
local aucmd = zkautocmd.aucmd

aucmd('TextYankPost', {
  desc = 'Highlight yanked text after yanking',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 150,
      on_visual = true,
    })
  end,
  group = augroup('zkhvan.editing'),
})
