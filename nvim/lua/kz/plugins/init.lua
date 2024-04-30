return {
  {
    'rhysd/git-messenger.vim',
    config = function()
      vim.g.git_messenger_max_popup_width = 70
      vim.g.git_messenger_max_popup_height = 24
    end,
  },

  -- =========================================================================
  -- ui
  -- =========================================================================
  { 'nvim-tree/nvim-web-devicons' },

  {
    'troydm/zoomwintab.vim',
    keys = {
      '<C-w>o',
      '<C-w><C-o>',
    },
    cmd = {
      'ZoomWinTabIn',
      'ZoomWinTabOut',
      'ZoomWinTabToggle',
    },
  },
}
