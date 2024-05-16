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
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('oil').setup()
      require('kz.mappings').bind_oil()
    end,
  },
}
