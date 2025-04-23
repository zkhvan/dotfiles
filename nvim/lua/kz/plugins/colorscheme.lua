-- ===========================================================================
-- Plugins related to color schemes
-- ===========================================================================

---@type LazySpec[]
return {
  {
    'zkhvan/vim-colors-meh',
    lazy = false, -- recommended to not lazy load colorscheme
    priority = 1000, -- recommended to set to high priorty for colorscheme
    dev = true,
    config = function()
      vim.cmd.colorscheme('meh')
    end,
  },
}
