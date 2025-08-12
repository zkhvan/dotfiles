local SIGNS = require('kz.diagnostic').SIGNS

---@type LazySpec[]
return {
  {
    'tpope/vim-scriptease',
  },

  {
    'Exafunction/windsurf.nvim',
    -- cmd = { 'Codeium' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'hrsh7th/nvim-cmp',
    },
    config = function()
      require('codeium').setup({
        -- Optionally disable cmp source if using virtual text only
        enable_cmp_source = false,
        virtual_text = {
          enabled = true,

          -- These are the defaults

          -- Set to true if you never want completions to be shown automatically.
          manual = false,
          -- A mapping of filetype to true or false, to enable virtual text.
          filetypes = {},
          -- Whether to enable virtual text of not for filetypes not specifically listed above.
          default_filetype_enabled = true,
          -- How long to wait (in ms) before requesting completions after typing stops.
          idle_delay = 75,
          -- Priority of the virtual text. This usually ensures that the completions appear on top of
          -- other plugins that also add virtual text, such as LSP inlay hints, but can be modified if
          -- desired.
          virtual_text_priority = 65535,
          -- Set to false to disable all key bindings for managing completions.
          map_keys = true,
          -- The key to press when hitting the accept keybinding but no completion is showing.
          -- Defaults to \t normally or <c-n> when a popup is showing.
          accept_fallback = nil,
          -- Key bindings for managing completions in virtual text mode.
          key_bindings = {
            -- Accept the current completion.
            accept = '<M-CR>',
            -- Accept the next word.
            accept_word = false,
            -- Accept the next line.
            accept_line = false,
            -- Clear the virtual text.
            clear = false,
            -- Cycle to the next completion.
            next = '<M-]>',
            -- Cycle to the previous completion.
            prev = '<M-[>',
          },
        },
      })
    end,
  },

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
  },
  {
    'tpope/vim-abolish',
  },

  {
    '2kabhishek/co-author.nvim',
    cmd = { 'CoAuthor' },
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
  },

  {
    'echasnovski/mini.align',
    version = false,
    config = function()
      require('mini.align').setup()
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
    'echasnovski/mini.surround',
    version = false,
    config = function()
      require('mini.surround').setup()
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
    'MeanderingProgrammer/render-markdown.nvim',
    tag = 'v8.2.0',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'echasnovski/mini.icons',
    }, -- if you use the mini.nvim suite
    ft = 'markdown',
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      heading = {
        backgrounds = {},
      },
      bullet = {
        icons = { '•', '◦' },
      },
      pipe_table = {
        cell = 'trimmed',
      },
    },
    config = function(_, opts)
      require('render-markdown').setup(opts)
      require('kz.mappings').bind_render_markdown()
    end,
  },

  -- {
  --   'OXY2DEV/markview.nvim',
  --   lazy = false,
  --   branch = 'dev',
  --   dependencies = {
  --     'nvim-treesitter/nvim-treesitter',
  --     'echasnovski/mini.icons',
  --   },
  --   config = function()
  --     local markview = require('markview')
  --     local presets = require('markview.presets')
  --     markview.setup({
  --       markdown = {
  --         headings = presets.headings.marker,
  --         list_items = { enable = false },
  --         tables = { block_decorator = false },
  --       },
  --     })
  --   end,
  -- },

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

  -- split/join
  -- Alternatives:
  -- - https://github.com/bennypowers/splitjoin.nvim
  -- - https://github.com/Wansmer/treesj (requires tree-sitter)
  -- - https://github.com/echasnovski/mini.splitjoin
  -- {
  --   'Wansmer/treesj',
  --   keys = { '<Leader>m', '<Leader>j', '<Leader>s' },
  --   dependencies = {
  --     'nvim-treesitter/nvim-treesitter',
  --   }, -- if you install parsers with `nvim-treesitter`
  --   config = function()
  --     require('treesj').setup({
  --       use_default_keymaps = false,
  --     })
  --     require('kz.mappings').bind_treesj()
  --   end,
  -- },
  {
    'echasnovski/mini.splitjoin',
    version = false,
    keys = 'gS',
    config = function()
      require('mini.splitjoin').setup()
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
      require('various-textobjs').setup({
        keymaps = {
          useDefaults = false,
        },
      })
      require('kz.mappings').bind_nvim_various_textobjs()
    end,
  },
}
