local tools = require('kz.tools')

tools.register({
  name = 'tilt_ls',
  type = 'lsp',
  lspconfig = function()
    ---@type lspconfig.Config
    return {
      mason_lspconfig = false,
    }
  end,
})
