-- init.lua

-- ============================================================================
-- high priority settings
-- ============================================================================

-- Keep the default runtime path for debugging
vim.g.runtimepath_default = vim.o.runtimepath

vim.g.mapleader = '\\'
vim.g.maplocalleader = ' '

-- ============================================================================
-- main
-- ============================================================================
--

require('zkhvan.providers') -- load providers first
require('zkhvan.opt')
require('zkhvan.mappings')
require('zkhvan.behaviors')
require('zkhvan.filetype')
require('zkhvan.lsp')

require('zkhvan.lazy')

-- ============================================================================
-- security
-- ============================================================================

-- Disallow unsafe local vimrc commands
-- Leave down here since it trims local settings
vim.o.secure = true

-- ============================================================================
