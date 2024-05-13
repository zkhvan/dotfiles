-- =========================================================================
-- LSP
-- =========================================================================
local tools = require('kz.tools')

return {
  {
    'deathbeam/lspecho.nvim',
    opts = {},
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Provide lua_ls configuration for neovim
      { 'folke/neodev.nvim', opts = {} },
    },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      -- border on :LspInfo window
      require('lspconfig.ui.windows').default_options.border = 'rounded'
    end,
  },

  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      tools.setup_mason_lspconfig()
    end,
  },
}
