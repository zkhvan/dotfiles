-- =========================================================================
-- LSP
-- =========================================================================
local tools = require('kz.tools')
local kzlsp = require('kz.lsp')

return {
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
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    config = function()
      local capabilities = kzlsp.base_config.capabilities
      -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      require('mason-lspconfig').setup({
        handlers = {
          function(server_name)
            local server = tools.servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend(
              'force',
              {},
              capabilities,
              server.capabilities or {}
            )
            require('lspconfig')[server_name].setup(server)
          end,
        },
      })

      local ensure_installed = vim.tbl_keys(tools.servers or {})
      vim.list_extend(ensure_installed, {
        'gopls',
        'lua_ls',
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup({
        ensure_installed = ensure_installed,
      })
    end,
  },
}
