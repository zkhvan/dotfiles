local format = require('kz.format')

format.register({
  filetype = 'lua',
  pipeline = {
    'stylua',
  },
})
