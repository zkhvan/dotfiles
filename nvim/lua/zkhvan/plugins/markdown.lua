--- @module 'lazy'
--- @type LazySpec[]
return {
  {
    'zk-org/zk-nvim',
    lazy = false,
    dependencies = {},
    config = function()
      local zk = require('zk')
      local zkc = require('zk.commands')

      zk.setup({
        picker = 'snacks_picker',
        lsp = {
          auto_attach = {
            enabled = false,
          },
        },
      })

      zkc.add('ZkDaily', function(options)
        local date = os.date('%Y-%m-%d')
        options = vim.tbl_deep_extend('force', {
          title = date,
          template = 'daily.md',
          group = 'log',
          dir = 'log',
        }, options or {})
        zk.new(options)
      end)

      zkc.add('ZkWeekly', function(options)
        -- Use Monday of the current week so the same file is reused all week
        local now = os.time()
        local wday = os.date('*t', now).wday -- 1=Sunday, 2=Monday, ...
        local offset = (wday - 2) % 7
        local monday = now - offset * 86400
        local date = os.date('%Y-%m-%d', monday)
        options = vim.tbl_deep_extend('force', {
          title = date .. '-weekly-review',
          template = 'weekly.md',
          group = 'log',
          dir = 'log',
        }, options or {})
        zk.new(options)
      end)

      local edit = function(title)
        zkc.add('Zk' .. title, function()
          zk.new({
            title = title,
          })
        end)
      end

      edit('Inbox')
      edit('Next')
      edit('Waiting')
      edit('Projects')
      edit('Someday')

      require('zkhvan.mappings').bind_zk()
    end,
  },

  {
    'opdavies/toggle-checkbox.nvim',
    ft = 'markdown',
  },

  {
    'brianhuster/live-preview.nvim',
    enabled = true,
    event = 'VeryLazy',
    config = function()
      require('livepreview.config').set({
        port = 10001,
      })
    end,
  },
}
