local M = {}

M.base_config = {
  capabilities = vim.lsp.protocol.make_client_capabilities(),
}

return M
