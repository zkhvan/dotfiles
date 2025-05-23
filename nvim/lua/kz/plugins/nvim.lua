-- ===========================================================================
-- Plugins that aid in the creation of neovim config and plugins
-- ===========================================================================

---@type LazySpec[]
return {
  -- https://github.com/AndrewRadev/bufferize.vim
  -- `:Bufferize messages` to get messages (or any :command) in a new buffer
  {
    'AndrewRadev/bufferize.vim',
    cmd = 'Bufferize',
    config = function()
      vim.g.bufferize_command = 'tabnew'
      vim.g.bufferize_keep_buffers = 1
    end,
  },
}
