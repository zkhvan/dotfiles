local mappings = require('kz.mappings')
local tools = require('kz.tools')

return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    dependencies = {
      'creativenull/efmls-configs-nvim',
    },
    config = function()
      tools.setup_conformconfig()
      mappings.bind_conform()
    end,
  },
}
