local SIGNS = require('kz.diagnostic').SIGNS

return {
  {
    'rhysd/git-messenger.vim',
    config = function()
      vim.g.git_messenger_max_popup_width = 70
      vim.g.git_messenger_max_popup_height = 24
    end,
  },

  {
    'echasnovski/mini.bracketed',
    version = false,
    config = function()
      require('mini.bracketed').setup({
        buffer = { suffix = '', options = {} }, -- using cybu
        comment = { suffix = 'c', options = {} },
        conflict = { suffix = 'x', options = {} },
        diagnostic = { suffix = '', options = {} }, -- don't want diagnostic float focus, have in mappings.lua
        file = { suffix = 'f', options = {} },
        indent = { suffix = '', options = {} }, -- confusing
        jump = { suffix = '', options = {} }, -- redundant
        location = { suffix = 'l', options = {} },
        oldfile = { suffix = 'o', options = {} },
        quickfix = { suffix = 'q', options = {} },
        treesitter = { suffix = '', options = {} },
        undo = { suffix = '', options = {} },
        window = { suffix = '', options = {} }, -- broken going to unlisted
        yank = { suffix = '', options = {} }, -- confusing
      })
    end,
  },

  {
    'andymass/vim-matchup',
    lazy = false,
    init = function()
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = {}
    end,
  },

  -- package diff
  -- https://github.com/vuki656/package-info.nvim
  {
    'davidosomething/package-info.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    event = { 'BufReadPost package.json' },
    config = function()
      require('package-info').setup({
        hide_up_to_date = true,
      })
    end,
  },

  -- =========================================================================
  -- ui
  -- =========================================================================
  { 'nvim-tree/nvim-web-devicons' },

  -- highlight undo/redo text change
  -- https://github.com/tzachar/highlight-undo.nvim
  {
    'tzachar/highlight-undo.nvim',
    keys = { 'u', '<c-r>' },
    config = function()
      require('highlight-undo').setup({})
    end,
  },

  {
    'lukas-reineke/headlines.nvim',
    ft = 'markdown',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    opts = {
      markdown = {
        bullets = {},
        fat_headlines = false,
      },
    }, -- or `opts = {}`
  },

  {
    'NvChad/nvim-colorizer.lua',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('colorizer').setup({
        buftypes = {
          '*',
          unpack(vim.tbl_map(function(v)
            return '!' .. v
          end, require('kz.utils.buffer').SPECIAL_BUFTYPES)),
        },
        filetypes = vim.tbl_extend('keep', {
          'css',
          'html',
          'scss',
        }, require('kz.jsts').filetypes),
        user_default_options = {
          css = true,
          tailwind = true,
        },
      })
    end,
  },

  -- remove buffers without messing up window layout
  {
    'echasnovski/mini.bufremove',
    version = '*',
    config = function()
      require('mini.bufremove').setup()
    end,
  },

  {
    'echasnovski/mini.move',
    config = function()
      require('mini.move').setup({
        mappings = require('kz.mappings').mini_move,
      })
    end,
  },

  -- pretty format quickfix and loclist
  {
    'yorickpeterse/nvim-pqf',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('pqf').setup({
        error = SIGNS.Error,
        warning = SIGNS.Warn,
        hint = SIGNS.Hint,
        info = SIGNS.Info,
      })
    end,
  },

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
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('gitsigns').setup({
        on_attach = require('kz.mappings').bind_gitsigns,
        preview_config = { border = 'rounded' },
      })
    end,
  },

  -- ]u [u mappings to jump to urls
  -- <A-u> to open link picker
  -- https://github.com/axieax/urlview.nvim
  {
    'axieax/urlview.nvim',
    keys = vim.tbl_values(require('kz.mappings').urlview),
    cmd = 'UrlView',
    config = function()
      require('kz.mappings').bind_urlview()
    end,
  },

  {
    'machakann/vim-sandwich',
  },

  {
    'kana/vim-textobj-user',
    dependencies = {
      'gilligan/textobj-lastpaste',
      'mattn/vim-textobj-url',
    },
    config = function()
      require('kz.mappings').bind_textobj()
    end,
  },

  {
    'chrisgrieser/nvim-various-textobjs',
    config = function()
      require('various-textobjs').setup({ useDefaultKeymaps = false })
      require('kz.mappings').bind_nvim_various_textobjs()
    end,
  },
}
