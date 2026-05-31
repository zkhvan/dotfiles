local M = {}

--- Detects whether Neovim is running over an SSH/remote connection.
--- @return boolean
function M.is_remote_connection()
  return vim.env.SSH_CONNECTION ~= nil
    or vim.env.SSH_CLIENT ~= nil
    or vim.env.SSH_TTY ~= nil
end

return M
