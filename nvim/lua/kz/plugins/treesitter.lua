-- ===========================================================================
-- nvim-treeitter
-- ===========================================================================

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
        auto_install = false,

        ignore_install = {},

        modules = {},

        highlight = {
          enable = true,
        },
      })
    end,
  },
}
