local format = require('kz.format')

format.register({
  filetype = 'typescript',
  pipeline = {
    'prettierd',
    'prettier',
  },
})
