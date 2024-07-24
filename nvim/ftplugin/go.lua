-- ftplugin/go.lua

if package.loaded['nvim-treesitter'] then
  vim.opt.foldmethod = 'expr'
  vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'

  vim.api.nvim_set_hl(0, '@constructor.go', { link = 'Function' })
  vim.api.nvim_set_hl(0, '@function.builtin.go', { link = 'Function' })
end