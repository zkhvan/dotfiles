---@type LazySpec[]
return {
  {
    'olexsmir/gopher.nvim',
    ft = 'go',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'mfussenegger/nvim-dap', -- (optional) only if you use `gopher.dap`
    },
    config = function()
      require('gopher').setup(
        ---@type gopher.Config
        {
          commands = {
            go = 'go',
            gomodifytags = 'gomodifytags',
            gotests = 'gotests',
            impl = 'impl',
            iferr = 'iferr',
            dlv = 'dlv',
          },
          gotag = {
            transform = 'snakecase',
          },
        }
      )
    end,
  },
}
