local zkautocmd = require('zkhvan.utils.autocmd')

local augroup = zkautocmd.augroup
local aucmd = zkautocmd.aucmd

aucmd('LspAttach', {
  desc = 'Bind LSP in buffer',
  callback = function(args)
    local bufnr = args.buf

    -- First LSP attached
    if not vim.b.has_lsp then
      vim.b.has_lsp = true
      require('zkhvan.mappings').bind_lsp(bufnr)
    end
  end,
  group = augroup('zkhvan.lsp'),
})
