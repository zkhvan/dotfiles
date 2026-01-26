-- @module 'lazy'
--- @type LazySpec[]
return {
  {
    'nvim-mini/mini.ai',
    version = false,
    opts = {},
  },

  {
    'nvim-mini/mini.align',
    version = false,
    opts = {},
  },

  {
    'nvim-mini/mini.bracketed',
    version = false,
    opts = {
      buffer = { suffix = 'b', options = {} },
      comment = { suffix = '', options = {} },
      conflict = { suffix = 'x', options = {} },
      diagnostic = { suffix = '', options = {} }, -- using default ]d, [d
      file = { suffix = 'f', options = {} },
      indent = { suffix = '', options = {} },
      jump = { suffix = '', options = {} },
      location = { suffix = 'l', options = {} },
      oldfile = { suffix = 'o', options = {} },
      quickfix = { suffix = 'q', options = {} },
      treesitter = { suffix = '', options = {} },
      undo = { suffix = '', options = {} },
      window = { suffix = '', options = {} },
      yank = { suffix = '', options = {} },
    },
  },

  {
    'nvim-mini/mini.surround',
    version = false,
    opts = {},
  },

  {
    'nvim-mini/mini.move',
    version = false,
    opts = {
      mappings = {
        -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
        left = '<C-h>',
        right = '<C-l>',
        down = '<C-j>',
        up = '<C-k>',

        -- Move current line in Normal mode
        line_left = '<C-h>',
        line_right = '<C-l>',
        line_down = '<C-j>',
        line_up = '<C-k>',
      },
    },
  },

  {
    -- adds various operators on text
    --     `g=` - Evaluate text and replace with output.
    --     `gx` - Exchange text regions.
    --     `gm` - Multiply (duplicate) text.
    --     `gr` - Replace text with register.
    --     `gs` - Sort text.
    'nvim-mini/mini.operators',
    version = false,
    opts = {
      exchange = {
        prefix = '',
      },
      replace = {
        prefix = '',
      },
    },
  },
}
