--- @module 'lazy'
--- @type LazySpec[]
return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      explorer = { enabled = false },
      indent = { enabled = false },
      image = {
        enabled = true,
        doc = {
          enabled = false,
          inline = false,
        }
      },
      input = { enabled = true },
      picker = {
        enabled = true,
        jump = { jumplist = false },
        formatters = {
          file = {
            filename_first = true,
            truncate = 100,
          },
        },
      },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = false },
      styles = {
        snacks_image = {
          relative = 'cursor',
          border = 'rounded',
          focusable = false,
          backdrop = false,
          row = 1,
          col = 1,
        },
      },
    },
    config = function(_, opts)
      require('snacks').setup(opts)
      require('zkhvan.mappings').bind_snacks()
    end,
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          local snacks = require('snacks')

          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            snacks.debug.inspect(...)
          end
          _G.bt = function()
            snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
          snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
          snacks.toggle
              .option('relativenumber', { name = 'Relative Number' })
              :map('<leader>uL')
          snacks.toggle.diagnostics():map('<leader>ud')
          snacks.toggle.line_number():map('<leader>ul')
          snacks.toggle
              .option('conceallevel', {
                off = 0,
                on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
              })
              :map('<leader>uc')
          snacks.toggle.treesitter():map('<leader>uT')
          snacks.toggle
              .option(
                'background',
                { off = 'light', on = 'dark', name = 'Dark Background' }
              )
              :map('<leader>ub')
          snacks.toggle.inlay_hints():map('<leader>uh')
          snacks.toggle.indent():map('<leader>ug')
          snacks.toggle.dim():map('<leader>uD')
        end,
      })
    end,
  },
}
