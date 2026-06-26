require('zkhvan.editor').tab(4)
require('zkhvan.format').register({
  filetype = 'go',
  pipeline = {
    'gofmt',
  },
})

vim.api.nvim_set_hl(0, '@constructor.go', { link = 'Function' })
vim.api.nvim_set_hl(0, '@function.builtin.go', { link = 'Function' })
