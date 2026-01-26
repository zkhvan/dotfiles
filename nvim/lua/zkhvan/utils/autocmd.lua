local M = {}

local groups = {}

function M.augroup(name, opts)
  if not groups[name] then
    opts = opts or {}
    groups[name] = vim.api.nvim_create_augroup(name, opts)
  end
  return groups[name]
end

M.aucmd = vim.api.nvim_create_autocmd

return M
