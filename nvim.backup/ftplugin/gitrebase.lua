-- ftplugin/go.lua

if package.loaded['nvim-treesitter'] then
  vim.api.nvim_set_hl(0, '@keyword.git_rebase', { link = 'Identifier' })
  vim.api.nvim_set_hl(0, '@constant.git_rebase', { link = 'Number' })
  vim.api.nvim_set_hl(0, '@none.git_rebase', { link = 'String' })
end
