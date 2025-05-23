-- ===========================================================================
-- lazy.nvim
--
-- Configure folke lazy.nvim plugin manager
-- ===========================================================================

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release,
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup(
  'kz.plugins',
  ---@type LazyConfig
  {
    root = vim.fn.stdpath('data') .. '/lazy',
    change_detection = {
      enabled = false,
    },
    dev = {
      path = '~/Projects/personal/zkhvan',
      fallback = true,
      patterns = { 'zkhvan' },
    },
    ui = {
      border = 'rounded',
    },
    performance = {
      rtp = {
        disabled_plugins = {
          'gzip',
          'matchit',
          'matchparen',
          'netrwPlugin',
          'tarPlugin',
          'tohtml',
          'tutor',
          'zipPlugin',
        },
      },
    },
  }
)
