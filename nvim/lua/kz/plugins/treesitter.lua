-- ===========================================================================
-- nvim-treeitter
-- ===========================================================================

local FT_TO_LANG_ALIASES = {
  dotenv = 'bash',
  tiltfile = 'starlark',
}

-- blacklist if highlighting doesn't look right or is worse than vim regex
local HIGHLIGHTING_DISABLED = {
  -- treesitter language, not ft
  -- see https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
  'dockerfile',
}

return {
  -- https://github.com/nvim-treesitter/nvim-treesitter/
  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = { 'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo' },
    build = function()
      require('nvim-treesitter.install').update({ with_sync = true })
    end,
    config = function()
      require('nvim-treesitter.configs').setup({
        -- A list of parser names
        ensure_installed = {
          'lua',
          'luadoc',
          'vim',
          'vimdoc',
        },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,

        ignore_install = {},

        modules = {},

        highlight = {
          enable = true,
          disable = function(lang, bufnr)
            return (
              require('kz.utils.buffer').is_huge({ bufnr = bufnr })
              or vim.tbl_contains(HIGHLIGHTING_DISABLED, lang)
            )
          end,
        },
      })

      -- Aliases
      for ft, parser in pairs(FT_TO_LANG_ALIASES) do
        vim.treesitter.language.register(parser, ft)
      end
    end,
  },
}
