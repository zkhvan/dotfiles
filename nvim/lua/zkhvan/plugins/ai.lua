--- @module 'lazy'
--- @type LazySpec[]
return {
  -- alternatives:
  -- https://github.com/zbirenbaum/copilot.lua
  --   - seems to be more neovim native, should look into it
  -- https://github.com/Exafunction/codeium.vim
  --   - windsurf ai autocompletions

  -- {
  --   'github/copilot.vim',
  --   cmd = 'Copilot',
  --   enabled = false,
  --   keys = {
  --     {
  --       '<M-CR>',
  --       'copilot#Accept("\\<CR>")',
  --       mode = 'i',
  --       expr = true,
  --       replace_keycodes = false,
  --       desc = 'Accept Copilot suggestion',
  --     },
  --     {
  --       '<C-]>',
  --       '<Plug>(copilot-next)',
  --       mode = 'i',
  --       desc = 'Next Copilot suggestion',
  --     },
  --   },
  --   init = function()
  --     vim.g.copilot_no_tab_map = true
  --   end,
  -- },

  {
    'coder/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' },
    lazy = false,
    opts = {
      terminal = {
        provider = 'none',
      },

      diff_opts = {
        open_in_new_tab = true,
      },
    },
    keys = {
      { '<leader>a',  nil,                            desc = 'AI/Claude Code' },
      { '<leader>ac', '<cmd>ClaudeCode<cr>',          desc = 'Toggle Claude' },
      { '<leader>af', '<cmd>ClaudeCodeFocus<cr>',     desc = 'Focus Claude' },
      { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
      {
        '<leader>aC',
        '<cmd>ClaudeCode --continue<cr>',
        desc = 'Continue Claude',
      },
      {
        '<leader>am',
        '<cmd>ClaudeCodeSelectModel<cr>',
        desc = 'Select Claude model',
      },
      { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>',      desc = 'Add current buffer' },
      {
        '<leader>as',
        '<cmd>ClaudeCodeSend<cr>',
        mode = 'v',
        desc = 'Send to Claude',
      },
      {
        '<leader>as',
        '<cmd>ClaudeCodeTreeAdd<cr>',
        desc = 'Add file',
        ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
      },
      -- Diff management
      { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
      { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>',   desc = 'Deny diff' },
    },
  },

  {
    'Exafunction/windsurf.nvim',
    -- cmd = { 'Codeium' },
    enabled = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    cond = function()
      -- Disable plugin if CWD path contains sensitive patterns
      local sensitive_patterns = {
        'sensitive',
        'secrets',
        'private',
        'credentials',
      }

      local cwd = vim.fn.getcwd():lower()
      for _, pattern in ipairs(sensitive_patterns) do
        if cwd:find(pattern, 1, true) then
          vim.notify(
            'Windsurf disabled: CWD contains "' .. pattern .. '"',
            vim.log.levels.WARN
          )
          return false
        end
      end

      return true
    end,
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
}
