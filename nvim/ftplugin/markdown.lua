vim.opt_local.textwidth = 0
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true
vim.opt_local.breakindentopt = 'list:2'
-- vim.cmd('Wrapwidth 80')

require('zkhvan.mappings').bind_toggle_checkbox(0)
