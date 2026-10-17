vim.opt_local.textwidth = 0
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true
-- 'breakindentopt' / 'formatlistpat' are set in after/ftplugin/markdown.lua
-- vim.cmd('Wrapwidth 80')

require('zkhvan.mappings').bind_toggle_checkbox(0)

local ok, zk_util = pcall(require, 'zk.util')
if ok and zk_util.notebook_root(vim.fn.expand('%:p')) ~= nil then
  vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, {
    buffer = true,
    desc = 'Follow zk wiki link',
  })
end
