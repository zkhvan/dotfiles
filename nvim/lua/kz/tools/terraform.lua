local tools = require('kz.tools')

tools.register({
  name = 'terraformls',
  type = 'lsp',
  lspconfig = function()
    ---@type lspconfig.Config
    return {
      settings = {
        terraform = {
          -- logFilePath = vim.env.XDG_STATE_HOME
        },
      },
    }
  end,
})
