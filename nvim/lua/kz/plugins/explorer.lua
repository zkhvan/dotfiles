return {
  -- {
  --   'nvim-tree/nvim-tree.lua',
  --   version = '*',
  --   lazy = false,
  --   dependencies = {
  --     'nvim-tree/nvim-web-devicons',
  --   },
  --   config = function()
  --     require('nvim-tree').setup({
  --       sync_root_with_cwd = true,
  --       actions = {
  --         open_file = {
  --           quit_on_open = true,
  --         },
  --       },
  --     })
  --     require('kz.mappings').bind_nvimtree()
  --   end,
  -- },

  {
    'stevearc/oil.nvim',
    lazy = false,
    priority = 1000,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('oil').setup({
        keymaps = {
          ['<C-s>'] = false,
          ['<C-h>'] = false,
          ['<C-w><C-s><CR>'] = {
            'actions.select',
            opts = { horizontal = true },
            desc = 'Open the entry in a horizontal split',
          },
          ['<C-w><C-v><CR>'] = {
            'actions.select',
            opts = { vertical = true },
            desc = 'Open the entry in a vertical split',
          },
        },
      })
      require('kz.mappings').bind_oil()
    end,
  },
}
