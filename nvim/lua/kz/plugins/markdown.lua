return {
  {
    'zk-org/zk-nvim',
    ft = 'markdown',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      local zk = require('zk')
      local zkc = require('zk.commands')

      zk.setup({
        picker = 'telescope',
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
    end,
  },
}
