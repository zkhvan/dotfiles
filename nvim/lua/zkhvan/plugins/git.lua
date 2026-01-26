--- @module 'lazy'
--- @type LazySpec[]
return {
  {
    'rhysd/git-messenger.vim',
    config = function()
      vim.g.git_messenger_max_popup_width = 70
      vim.g.git_messenger_max_popup_height = 24
    end,
  },

  {
    'tpope/vim-fugitive',
    dependencies = {
      'tpope/vim-rhubarb', -- GBrowse for GitHub
    },
    config = function()
      require('zkhvan.mappings').bind_fugitive()
    end,
  },

  {
    'rhysd/committia.vim',
    lazy = false, -- just in case
    init = function()
      vim.g.committia_open_only_vim_starting = 0
      vim.g.committia_use_singlecolumn = 'always'
    end,
  },

  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signs_staged_enable = true,
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 1000,
      },
      preview_config = {
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
      },
    },
    config = function(_, opts)
      require('gitsigns').setup(opts)
      require('zkhvan.mappings').bind_gitsigns()
    end,
  },
}
