local tools = require('kz.tools')

tools.register({
  name = 'tailwindcss',
  type = 'lsp',
  lspconfig = function()
    ---@type lspconfig.Config
    return {
      settings = {
        tailwindCSS = {
          experimental = {
            classRegex = {
              { 'cva\\(([^)]*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
              { 'cx\\(([^)]*)\\)', "(?:'|\"|`)([^']*)(?:'|\"|`)" },
            },
          },
        },
      },
    }
  end,
})
