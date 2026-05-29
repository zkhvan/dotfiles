require('zkhvan.editor').space(2)
require('zkhvan.format').register({
  filetype = 'javascript',
  pipeline = {
    'prettier',
  },
})

vim.opt_local.suffixesadd:append('.jsx')
vim.opt_local.suffixesadd:append('.json')
vim.opt_local.suffixesadd:append('.vue')
vim.opt_local.suffixesadd:append('.index.js')
vim.opt_local.suffixesadd:append('.index.jsx')
