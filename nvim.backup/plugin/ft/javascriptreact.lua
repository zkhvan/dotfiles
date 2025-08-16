local format = require('kz.format')

format.register({
  filetype = 'javascriptreact',
  pipeline = {
    'prettierd',
    'prettier',
  },
})
