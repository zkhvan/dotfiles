local tools = require('kz.tools')

tools.register({
  name = 'zk',
  type = 'lsp',
  lspconfig = function()
    ---@type lspconfig.Config|{}
    return {
      on_attach = function(client, bufnr)
        require('kz.mappings').bind_zk_lsp(client, bufnr)
      end,
    }
  end,
})
