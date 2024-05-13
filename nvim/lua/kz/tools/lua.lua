local tools = require('kz.tools')

tools.register({
  name = 'lua_ls',
  type = 'lsp',
  lspconfig = function()
    -- Configuration for neovim is done with 'folke/neodev.nvim'

    ---@type lspconfig.Config
    return {
      settings = {
        Lua = {
          format = { enable = false },
          hint = { enable = true },
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            -- version = "LuaJIT",
          },
          workspace = {
            maxPreload = 1000,
            preloadFileSize = 500,
            checkThirdParty = false,
            library = {
              -- vim.env.VIMRUNTIME,
              -- "${3rd}/luv/library",
              -- "${3rd}/busted/library",
              -- pull in all of 'runtimepath'. NOTE: this is a lot slower
              -- unpack(vim.api.nvim_get_runtime_file("", true)),
            },
          },
        },
      },
    }
  end,
})
