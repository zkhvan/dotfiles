local format = require('kz.format')

format.register({
  filetype = 'javascript',
  pipeline = {
    'prettierd',
    'prettier',
  },
})
