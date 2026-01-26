require('zkhvan.format').register({
  filetype = 'python',
  pipeline = {
    'black',
    'isort',
  },
})
