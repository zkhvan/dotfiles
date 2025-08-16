local format = require('kz.format')

format.register({
  filetype = 'json',
  pipeline = {
    'prettier',
  },
})
