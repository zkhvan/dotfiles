require('zkhvan.editor').tab(4)

vim.api.nvim_set_hl(0, '@constructor.go', { link = 'Function' })
vim.api.nvim_set_hl(0, '@function.builtin.go', { link = 'Function' })
