--- @module 'lazy'
--- @type LazySpec[]
return {
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
        skip_confirm_for_simple_edits = true,
      })
      require('zkhvan.mappings').bind_oil()
    end,
  },
}
