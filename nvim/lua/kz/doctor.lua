-- General info about current config and buffers

local M = {}

M.warnings = {}
M.errors = {}

M.error = function(params)
  table.insert(M.errors, params)
end

M.warn = function(params)
  table.insert(M.warnings, params)
end

vim.api.nvim_create_user_command('KZDoctorErrors', function()
  vim.cmd.Bufferize("lua vim.print(require('kz.doctor').errors)")
end, { desc = 'Show KZDoctor errors' })

vim.api.nvim_create_user_command('KZDoctorWarnings', function()
  vim.cmd.Bufferize("lua vim.print(require('kz.doctor').warnings)")
end, { desc = 'Show KZDoctor warnings' })

return M
