local format = require('zkhvan.format')

--- @module 'lazy'
--- @type LazySpec[]
return {
  {
    'stevearc/conform.nvim',
    dependencies = {
      'mason.nvim',
      'creativenull/efmls-configs-nvim',
    },
    event = { 'BufWritePre' },
    cmd = 'ConformInfo',
    config = function(_, opts)
      require('conform').setup({
        formatters_by_ft = format.pipelines,
        format_on_save = function(bufnr)
          -- Disable with a global or buffer-local variable
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end

          return {
            timeout_ms = 2000,
            lsp_fallback = false,
          }
        end,
        default_format_opts = {
          lsp_fallback = true,
          -- stop_after_first = true,
        },
      })

      vim.bo.formatexpr = "v:lua.require('conform').formatexpr()"
    end,
  },
}
