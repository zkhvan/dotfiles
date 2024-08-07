local format = require('kz.format')

format.register({
  filetype = 'html',
  pipeline = {
    'prettier',
  },
})
