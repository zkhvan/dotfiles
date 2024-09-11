-- =========================================================================
-- LSP
-- =========================================================================
local tools = require('kz.tools')
local lsp = require('kz.lsp')

return {
  {
    'deathbeam/lspecho.nvim',
    opts = {},
  },

  {
    'hrsh7th/cmp-nvim-lsp', -- provides some capabilities
    config = function()
      local cnl = require('cmp_nvim_lsp')
      cnl.setup()
      lsp.base_config.capabilities = vim.tbl_deep_extend(
        'force',
        lsp.base_config.capabilities,
        cnl.default_capabilities()
      )
    end,
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

      -- TODO: REMOVE
      -- Need to configure a way to install unmanaged lsps (not in
      -- mason-lspconfig)
      require('lspconfig').tilt_ls.setup({})
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

  {
    'creativenull/efmls-configs-nvim',
    version = 'v1.x.x',
    dependencies = {
      'neovim/nvim-lspconfig',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      tools.setup_efmconfig()
    end,
  },

  {
    'ray-x/go.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    ft = { 'go', 'gomod' },
    event = { 'CmdlineEnter' },
    config = function()
      require('go').setup()
    end,
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
}
