--- @module 'lazy'
--- @type LazySpec[]
return {
  {
    'andymass/vim-matchup',
    config = function()
      require('match-up').setup({
        treesitter = {
          stopline = 500
        }
      })
    end,
  },
  {
    'romainl/vim-qf',
  }
}
