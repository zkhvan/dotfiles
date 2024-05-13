-- init.lua
-- Neovim init (in place of vimrc)

-- ============================================================================
-- Settings vars
-- ============================================================================

-- Fallback for vims with no env access
vim.g.vdotdir = vim.fn.expand(
  vim.fn.empty('$VDOTDIR') == 1 and '$XDG_CONFIG_DIR/nvim' or '$VDOTDIR'
)
vim.g.vdordir = vim.fs.dirname(vim.env.MYVIMRC)

vim.g.kz_runtimepath_default = vim.o.runtimepath
vim.g.mapleader = '\\'

-- ============================================================================
-- Settings
-- ============================================================================

require('kz.providers') -- load providers first
require('kz.opt')
require('kz.builtin-syntax')
require('kz.builtin-plugins')
require('kz.terminal')
require('kz.behaviors')

require('kz.tools.lua')
require('kz.tools.go')
require('kz.tools.generic')

require('kz.lazy')

require('kz.lsp.floats')

-- ============================================================================
-- Security
-- ============================================================================

-- Disallow unsafe local vimrc commands
-- Leave down here since it trims local settings
vim.o.secure = true

-- =============================================================================
