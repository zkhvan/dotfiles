vim.lsp.config.circleci = {
  name = 'circleci',
  filetypes = { 'yml', 'yaml' },
  root_dir = function(bufnr, on_dir)
    local util = require('lspconfig.util')
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local dir = vim.fn.fnamemodify(fname, ':h')

    -- Only attach the client if the file is in a .circleci directory
    if dir:match('%.circleci') then
      on_dir(util.root_pattern('.git')(fname))
    end
  end,
  cmd = {
    'circleci-yaml-language-server',
    '-schema',
    vim.fn.stdpath('data')
      .. '/mason/packages/circleci-yaml-language-server/schema.json',
    '-stdio',
  },
}
vim.lsp.enable('circleci')
