local format = require('kz.format')

format.register({
  filetype = 'typescriptreact',
  pipeline = {
    'prettierd',
    'prettier',
  },
})
