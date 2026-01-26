require('zkhvan.editor').space(2)
require('zkhvan.format').register({
  filetype = 'json',
  pipeline = {
    'prettierd',
    'prettier',
  }
})
