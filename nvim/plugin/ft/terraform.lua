local format = require('kz.format')

format.register({
  filetype = 'terraform',
  pipeline = {
    'terraform_fmt',
  },
})
