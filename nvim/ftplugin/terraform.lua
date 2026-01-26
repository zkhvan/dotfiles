require('zkhvan.editor').space(2)
require('zkhvan.format').register({
  filetype = 'terraform',
  pipeline = {
    'terraform_fmt',
  },
})

