local zkautocmd = require('zkhvan.utils.autocmd')

local augroup = zkautocmd.augroup
local aucmd = zkautocmd.aucmd

aucmd('BufWinEnter', {
  desc = 'Restore cursor position',
  callback = function(_)
    require('zkhvan.remember').set_cursor_position()
  end,
  group = augroup('zkhvan.remember'),
})

aucmd('VimResized', {
  desc = 'Automatically resize windows when resizing Vim',
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
  group = augroup('zkhvan.window'),
})

-- @TODO keep an eye on https://github.com/neovim/neovim/issues/23581
aucmd('WinLeave', {
  desc = 'Toggle close->open loclist so it is always under the correct window',
  callback = function()
    if vim.bo.buftype == 'quickfix' then
      -- Was in loclist already
      return
    end
    local loclist_winid = vim.fn.getloclist(0, { winid = 0 }).winid
    if loclist_winid == 0 then
      return
    end

    local leaving = vim.api.nvim_get_current_win()
    aucmd('WinEnter', {
      callback = function()
        if vim.bo.buftype == 'quickfix' then
          -- Left main window and went into the loclist
          return
        end
        local entering = vim.api.nvim_get_current_win()
        vim.o.eventignore = 'all'
        vim.api.nvim_set_current_win(leaving)
        vim.cmd.lclose()
        vim.cmd.lwindow()
        vim.api.nvim_set_current_win(entering)
        vim.o.eventignore = ''
      end,
      once = true,
    })
  end,
  group = augroup('zkhvan.window'),
})

aucmd('QuitPre', {
  desc = 'Auto close corresponding loclist when quitting a window',
  callback = function()
    if vim.bo.filetype ~= 'qf' then
      vim.cmd('silent! lclose')
    end
  end,
  nested = true,
  group = augroup('zkhvan.window'),
})

aucmd('WinEnter', {
  desc = 'Quit when quickfix is the last window',
  callback = function()
    local should_close = false

    if vim.bo.filetype == 'qf' then
      should_close = true
    end

    if vim.bo.filetype == 'neotest-summary' then
      should_close = true
    end

    if should_close and vim.fn.winnr('$') == 1 then
      vim.cmd('quit')
    end
  end,
  group = augroup('zkhvan.window'),
})
