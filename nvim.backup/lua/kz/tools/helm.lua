local tools = require('kz.tools')

tools.register({
  name = 'helm_ls',
  type = 'lsp',
  lspconfig = function()
    ---@type lspconfig.Config|{}
    return {}
  end,
})
