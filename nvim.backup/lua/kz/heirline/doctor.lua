return {
  {
    condition = function()
      return #require('kz.doctor').errors > 0
    end,
    {
      provider = '  ',
      hl = 'Error',
    },
  },
  {
    condition = function()
      return #require('kz.doctor').warnings > 0
    end,
    {
      provider = '  ',
      hl = 'Comment',
    },
  },
}
