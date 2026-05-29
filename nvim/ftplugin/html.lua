require('zkhvan.editor').space(2)
require('zkhvan.format').register({
  filetype = 'html',
  pipeline = {
    'prettier',
  },
})
