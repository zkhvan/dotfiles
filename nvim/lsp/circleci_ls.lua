return {
  cmd = {
    'circleci-yaml-language-server',
    '-schema',
    vim.fn.stdpath('data')
      .. '/mason/packages/circleci-yaml-language-server/schema.json',
    '-stdio',
  },
  filetypes = { 'yml', 'yaml' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local dir = vim.fn.fnamemodify(fname, ':h')

    -- Only attach the client if the file is in a .circleci directory
    if dir:match('%.circleci') then
      on_dir(
        vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
      )
    end
  end,
}
