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

-- If FocusGained ever misses events (Ghostty/tmux drops focus, terminal
-- multiplexer chain, etc.), add 'CursorHold' and 'CursorHoldI' to the event
-- list — they fire after `updatetime` of idleness and provide a backstop.
aucmd('FocusGained', {
  desc = 'Reload buffers when external edits occur (Ghostty, tmux popups)',
  callback = function()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if
        vim.api.nvim_buf_is_loaded(bufnr)
        and vim.bo[bufnr].buftype == ''
      then
        vim.cmd('checktime ' .. bufnr)
      end
    end
  end,
  group = augroup('zkhvan.autoread'),
})
