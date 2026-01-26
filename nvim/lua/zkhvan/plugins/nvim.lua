--- @module 'lazy'
--- @type LazySpec[]
return {
  {
    'folke/lazydev.nvim',
    opts = {},
  },

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    --- @module 'which-key'
    --- @type wk.Opts
    opts = {
      delay = 1000,
    },
    config = function(_, opts)
      require('which-key').setup(opts)
      require('zkhvan.mappings').bind_which_key()
    end,
  },

  {
    'yorickpeterse/nvim-pqf',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
  },

  {
    'yssl/QFEnter',
    ft = 'qf',
    init = function()
      vim.g.qfenter_keymap = {
        open = { '<CR>' },
        hopen = { '<C-w><CR>' },
        vopen = { '<C-w><C-v><CR>' },
      }
    end,
  },

  {
    'nvim-tree/nvim-web-devicons',
  },

  {
    'tzachar/highlight-undo.nvim',
    keys = { 'u', '<c-r>' },
    opts = {},
  },

  -- ]u [u mappings to jump to urls
  -- <A-u> to open link picker
  -- https://github.com/axieax/urlview.nvim
  {
    'axieax/urlview.nvim',
    cmd = 'UrlView',
    opts = {
      jump = {
        prev = ']u',
        next = '[u',
      },
    },
    keys = {
      { ']u', '[u' },
    },
  },

  {
    'chrisgrieser/nvim-various-textobjs',
    dependencies = {},
    opts = {
      keymaps = {
        useDefaults = false,
      },
    },
    config = function(_, opts)
      require('various-textobjs').setup(opts)
      require('zkhvan.mappings').bind_various_textobjs()
    end,
  },

  {
    'HakonHarnes/img-clip.nvim',
    event = 'VeryLazy',
    opts = {
      default = {
        dir_path = 'assets',
        extension = 'webp',
        file_name = '%Y-%m-%d-%H-%M-%S',
        use_absolute_path = false,
        relative_to_current_file = true,
      },
    },
    keys = {
      { '<leader>p', '<cmd>PasteImage<cr>', desc = 'Paste image from clipboard' },
    },
  },
}
