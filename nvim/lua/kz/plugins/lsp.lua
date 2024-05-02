-- =========================================================================
-- LSP
-- =========================================================================

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
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      require('mason-lspconfig').setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        }
      })
    end,
  }
}
