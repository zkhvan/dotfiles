local zkstring = require('zkhvan.utils.string')

local M = {}

--- Creates a horizontal line to `&textwidth`.
---
--- Before adding the horizontal line, ensures that there's a space before the
--- horiztonal line.
--- @param char string The character to repeat.
function M.fill(char)
  local line = vim.api.nvim_get_current_line()
  if not zkstring.endswithany(line, { ' ', '\t' }) then
    vim.api.nvim_put({ ' ' }, 'c', true, true)
  end

  local col = vim.fn.virtcol('$')
  local tw = vim.bo.textwidth - 1

  local remaining = tw - col
  local text = string.rep(char, remaining)

  -- Repeat the characters and simulate adding a newline with the user's
  -- indentation settings
  vim.api.nvim_put({ text }, 'c', true, true)
  vim.api.nvim_feedkeys('o', 'nt', true)
end

return M
