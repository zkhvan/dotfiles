--- @module 'lazy'
--- @type LazySpec[]
return {
  {
    'mistweaverco/kulala.nvim',
    ft = { 'http', 'rest' },
    keys = {
      {
        '<leader>Rs',
        function()
          require('kulala').run()
        end,
        ft = { 'http', 'rest' },
        desc = 'Send request',
      },
      {
        '<leader>Ra',
        function()
          require('kulala').run_all()
        end,
        ft = { 'http', 'rest' },
        desc = 'Send all requests',
      },
      {
        '<leader>Rr',
        function()
          require('kulala').replay()
        end,
        ft = { 'http', 'rest' },
        desc = 'Replay last request',
      },
      {
        '<leader>Rb',
        function()
          require('kulala').scratchpad()
        end,
        ft = { 'http', 'rest' },
        desc = 'Open scratchpad',
      },
      {
        '<leader>Rc',
        function()
          require('kulala').copy()
        end,
        ft = { 'http', 'rest' },
        desc = 'Copy as cURL',
      },
      {
        '<leader>RC',
        function()
          require('kulala').from_curl()
        end,
        ft = { 'http', 'rest' },
        desc = 'Paste from cURL',
      },
      {
        '<leader>Rq',
        function()
          require('kulala').close()
        end,
        ft = { 'http', 'rest' },
        desc = 'Close response window',
      },
      {
        '<leader>Re',
        function()
          require('kulala').set_selected_env()
        end,
        ft = { 'http', 'rest' },
        desc = 'Select environment',
      },
      {
        '[r',
        function()
          require('kulala').jump_prev()
        end,
        ft = { 'http', 'rest' },
        desc = 'Previous request',
      },
      {
        ']r',
        function()
          require('kulala').jump_next()
        end,
        ft = { 'http', 'rest' },
        desc = 'Next request',
      },
    },
    --- @type kulala.Config
    opts = {
      global_keymaps = false,
      kulala_keymaps = false,
    },
  },
}
