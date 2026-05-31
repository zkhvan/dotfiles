--- @module 'lazy'
--- @type LazySpec[]
return {
  {
    'andymass/vim-matchup',
    config = function()
      require('match-up').setup({
        treesitter = {
          stopline = 500,
        },
      })
    end,
  },

  {
    'rickhowe/wrapwidth',
    enabled = false,
  },

  {
    'romainl/vim-qf',
  },

  {
    -- Yank ring: records yanks/deletes and lets you cycle through history
    -- after a put with <C-p>/<C-n>.
    'gbprod/yanky.nvim',
    opts = {},
    keys = {
      { 'y', '<Plug>(YankyYank)', mode = { 'n', 'x' }, desc = 'Yank text' },
      { 'p', '<Plug>(YankyPutAfter)', mode = { 'n', 'x' }, desc = 'Put after cursor' },
      { 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' }, desc = 'Put before cursor' },
      { 'gp', '<Plug>(YankyGPutAfter)', mode = { 'n', 'x' }, desc = 'Put after selection' },
      { 'gP', '<Plug>(YankyGPutBefore)', mode = { 'n', 'x' }, desc = 'Put before selection' },
      { '<C-p>', '<Plug>(YankyPreviousEntry)', desc = 'Cycle to previous yank' },
      { '<C-n>', '<Plug>(YankyNextEntry)', desc = 'Cycle to next yank' },
      { ']p', '<Plug>(YankyPutIndentAfterLinewise)', desc = 'Put indented after (linewise)' },
      { '[p', '<Plug>(YankyPutIndentBeforeLinewise)', desc = 'Put indented before (linewise)' },
    },
  },
}
