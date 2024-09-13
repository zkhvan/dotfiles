local kzstring = require('kz.utils.string')

local M = {}

--- Create a horizontal line to `&textwidth`
---@param char string A single character to repeat
M.fill = function(char)
  if not kzstring.endswithany(vim.api.nvim_get_current_line(), {' ', '\t'}) then
    vim.api.nvim_put({ ' ' }, 'c', true, true)
  end

  local col = vim.fn.virtcol('$')

  -- Add padding
  local textwidth = vim.bo.textwidth - 1

  local remaining = textwidth - col
  local text = string.rep(char, remaining)

  vim.api.nvim_put({ text }, 'c', true, true)
  vim.api.nvim_feedkeys("o", "nt", true)
end

return M
