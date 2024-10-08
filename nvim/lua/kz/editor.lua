local M = {}

M.space = function(size)
  vim.bo.expandtab = true
  vim.bo.shiftwidth = size
  vim.bo.softtabstop = size
end

M.tab = function(size)
  vim.bo.expandtab = false
  vim.bo.shiftwidth = size
  vim.bo.softtabstop = size
  vim.bo.tabstop = size
end

return M
