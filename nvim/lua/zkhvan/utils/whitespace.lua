local M = {}

--- Clean whitespace in the buffer
--- This function:
--- - Replaces tabs with spaces
--- - Converts DOS line endings to Unix
--- - Removes trailing whitespace
--- - Removes non-breaking spaces and replaces them with regular spaces
function M.clean()
  -- Save the current view (cursor position, etc.)
  local view = vim.fn.winsaveview()

  -- Replace tabs with spaces based on current tabstop settings
  vim.cmd('silent! %retab')

  -- Turn DOS returns ^M into real returns
  -- The :substitute command with 'e' flag suppresses errors if pattern not found
  vim.cmd([[silent! %s/\r/\r/eg]])

  -- Remove trailing whitespace from all lines
  vim.cmd([[silent! %s/\s\+$//e]])

  -- Remove non-breaking space (U+00A0)
  vim.cmd([[silent! %s/ //eg]])

  -- Replace   (U+2003 em space) with regular space
  vim.cmd([[silent! %s/ / /eg]])

  -- Restore the view
  vim.fn.winrestview(view)
end

return M
