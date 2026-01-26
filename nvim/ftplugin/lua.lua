require('zkhvan.editor').space(2)
require('zkhvan.format').register({
  filetype = 'lua',
  pipeline = {
    'stylua',
  },
})

