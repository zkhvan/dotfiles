return {
  {
    'davidosomething/everandever.nvim',
  },

  {
    'rebelot/heirline.nvim',
    dependencies = {
      'davidosomething/everandever.nvim',
    },
    config = function()
      local ALWAYS = 2
      vim.o.showtabline = ALWAYS

      local GLOBAL = 3
      vim.o.laststatus = GLOBAL

      require('heirline').setup({
        statusline = require('kz.heirline.statusline-default'),
        tabline = require('kz.heirline.tabline'),
        winbar = require('kz.heirline.winbar'),
        opts = {
          -- if the callback returns true, the winbar will be disabled for that window
          -- the args parameter corresponds to the table argument passed to autocommand callbacks. :h nvim_lua_create_autocmd()
          disable_winbar_cb = function(args)
            return require('heirline.conditions').buffer_matches({
              buftype = vim.tbl_filter(function(bt)
                return not vim.tbl_contains(
                  { 'help', 'quickfix', 'terminal' },
                  bt
                )
              end, require('kz.utils.buffer').SPECIAL_BUFTYPES),
            }, args.buf)
          end,
        },
      })

      vim.api.nvim_create_autocmd('colorscheme', {
        desc = 'Clear heirline color cache',
        callback = function()
          require('heirline').reset_highlights()
        end,
        group = vim.api.nvim_create_augroup('kzheirline', {}),
      })
    end,
  },
}
