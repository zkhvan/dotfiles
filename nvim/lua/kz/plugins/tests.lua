local mappings = require('kz.mappings')

---@diagnostic disable: missing-fields
---@type LazySpec[]
return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',

      'fredrikaverpil/neotest-golang',
    },
    config = function()
      require('neotest').setup(
        ---@type neotest.Config
        {
          -- See all config options with :h neotest.Config
          discovery = {
            -- Drastically improve performance in ginormous projects by
            -- only AST-parsing the currently opened buffer.
            enabled = false,
            -- Number of workers to parse files concurrently.
            -- A value of 0 automatically assigns number based on CPU.
            -- Set to 1 if experiencing lag.
            concurrent = 1,
          },
          running = {
            -- Run tests concurrently when an adapter provides multiple commands to run.
            concurrent = true,
          },
          summary = {
            -- Enable/disable animation of icons.
            animated = false,
          },
          adapters = {
            require('neotest-golang')({
              go_test_args = {
                '-v',
                '-race',
                '-coverprofile=' .. vim.fn.getcwd() .. '/coverage.out',
              },
            }),
          },
        }
      )

      mappings.bind_neotest()
    end,
  },
}
