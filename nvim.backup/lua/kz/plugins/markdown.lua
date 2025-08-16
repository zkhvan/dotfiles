local mappings = require('kz.mappings')

---@type LazySpec[]
return {
  {
    'jakewvincent/mkdnflow.nvim',
    config = function()
      require('mkdnflow').setup({
        -- Config goes here; leave blank for defaults
        modules = {
          bib = false,
          buffers = true,
          conceal = true,
          cursor = true,
          folds = true,
          foldtext = true,
          links = true,
          lists = true,
          maps = false,
          paths = true,
          tables = false,
          yaml = false,
          cmp = false,
        },
      })

      mappings.bind_mkdnflow()
    end,
  },

  {
    'zk-org/zk-nvim',
    lazy = false,
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

      zkc.add('ZkWeekly', function(options)
        local date = os.date('%Y-%m-%d')
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
    end,
  },
}
