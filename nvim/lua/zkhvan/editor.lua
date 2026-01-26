local M = {}

--- @param size number The number of spaces to use
function M.space(size)
  vim.bo.expandtab = true
  vim.bo.shiftwidth = size
  vim.bo.softtabstop = size
end

--- @param size number The number of spaces a tab should represent
function M.tab(size)
  vim.bo.expandtab = false
  vim.bo.shiftwidth = size
  vim.bo.softtabstop = size
  vim.bo.tabstop = size
end

return M
