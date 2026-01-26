require('zkhvan.editor').space(2)
require('zkhvan.format').register({
  filetype = 'typescript',
  pipeline = {
    'prettierd',
  },
})

vim.opt_local.suffixesadd:append('.tsx')
vim.opt_local.suffixesadd:append('.index.ts')
vim.opt_local.suffixesadd:append('.index.tsx')
