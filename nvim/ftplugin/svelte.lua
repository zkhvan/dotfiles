-- ftplugin/svelte.lua

vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2

if package.loaded['nvim-treesitter'] then
  vim.api.nvim_set_hl(0, '@lsp.type.class.svelte', { link = 'Special' })
  vim.api.nvim_set_hl(0, '@lsp.type.type.svelte', { link = 'Special' })
end
