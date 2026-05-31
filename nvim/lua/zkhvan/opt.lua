-- opt.lua

vim.g.clipboard = 'osc52'
vim.o.clipboard = 'unnamedplus'

-- ===========================================================================
-- reading
-- ===========================================================================

vim.o.modelines = 1

vim.o.autoread = true

-- ===========================================================================
-- saving
-- ===========================================================================

vim.o.fileformats = 'unix,mac,dos'

-- if we have a swap conflict, FZF has issues opening the file (and doesn't
-- prompt correctly)
vim.o.swapfile = false

-- use backup files when writing (create new file, replace old one with new
-- one)
vim.o.writebackup = false

-- do not leave around backup.xyz~ files
vim.o.backup = false

-- overwrite the original file, preserves special file types like symlinks
vim.o.backupcopy = 'yes'

-- bumped '100 to '1000 to save more previous files
-- bumped <50 to <100 to save more register lines
-- bumped s10 to s100 for to allow up to 100kb of data per item
vim.o.shada = "!,'1000,<100,s100,h"

vim.opt.backupskip:append('/private/tmp/*') -- edit crontab files
vim.opt.backupskip:append('~/.secret/*')

vim.o.updatetime = 250

vim.o.undofile = true
vim.o.undolevels = 1000
vim.o.undoreload = 10000

-- ===========================================================================
-- display
-- ===========================================================================

vim.o.title = true

-- no beeps or flashes
vim.o.visualbell = false
vim.o.errorbells = false

-- line numbers
vim.o.number = true
vim.o.numberwidth = 5

-- show context around current cursor position
vim.o.scrolloff = 8
vim.o.sidescrolloff = 16

vim.o.textwidth = 78

-- the line will be right after column 80, &tw+3
vim.opt.colorcolumn = { '+3', '120' }
vim.o.cursorline = true

-- min 1, max 4 signs
vim.o.signcolumn = 'yes'

-- don't syntax highlight long lines
vim.o.synmaxcol = 512

vim.o.showtabline = 0 -- start OFF, toggle =2 to show tabline
vim.o.laststatus = 2 -- always show all statuslines

-- this is slow on some terminals and often gets hidden by msgs so leave it off
vim.o.showcmd = false
vim.o.showmode = false -- don't show -- INSERT -- in cmdline

vim.o.winborder = 'rounded'

-- ===========================================================================
-- input
-- ===========================================================================

-- enable mouse
vim.o.mouse = 'a'

-- typing key combos
vim.o.timeout = false

-- ===========================================================================
-- built-in completion
-- ===========================================================================

-- don't consider = symbol as part filename.
vim.opt.isfname:remove('=')

vim.opt.completeopt:append('noselect') -- don't select first thing

-- ===========================================================================
-- Message output on vim actions
-- ===========================================================================

vim.opt.shortmess:append({
  c = true, -- Disable "Pattern not found" messages
  m = true, -- use "[+]" instead of "[Modified]"
  r = true, -- use "[RO]" instead of "[readonly]"
  I = true, -- don't give the intro message when starting Vim |:intro|.
  S = true, -- hide search info echoing (i have a statusline for that)
  W = true, -- don't give "written" or "[w]" when writing a file
})

-- ===========================================================================
-- Window splitting and buffers
-- ===========================================================================

vim.o.splitbelow = true
vim.o.splitright = true

-- remember undo after quitting
vim.o.hidden = true

-- reveal already opened files from the quickfix window instead of opening new
-- buffers
vim.o.switchbuf = 'uselast,useopen'

vim.o.startofline = false -- don't jump to col1 on switch buffer

-- ===========================================================================
-- code folding
-- ===========================================================================

vim.o.foldlevel = 999 -- very high === all folds open
vim.o.foldlevelstart = 99 -- show all folds by default
vim.o.foldenable = false
vim.o.foldexpr = "v:lua.require'zkhvan.ui'.foldexpr()"
vim.o.foldmethod = 'expr'
vim.o.foldtext = ''

-- ===========================================================================
-- trailing whitespace
-- ===========================================================================

vim.o.list = true
vim.opt.listchars = {
  tab = '▶ ', -- this must be two chars, see :h listchars
  trail = '·', -- trailing spaces
  nbsp = '⣿', -- non-breakable spaces
  extends = '»', -- show cut off when nowrap
  precedes = '«', -- show cut off when nowrap
}

-- ===========================================================================
-- diffing
-- ===========================================================================

-- note this is += since fillchars was defined in the window config
vim.opt.fillchars = { diff = '⣿' }
vim.opt.diffopt = {
  vertical = true, -- use in vertical diff mode
  filler = true, -- blank lines to keep sides aligne
  iwhite = true, -- ignore whitespace changes
}

-- ===========================================================================
-- input auto-formatting (global defaults)
-- probably need to update these in after/ftplugin too since ftplugins will
-- probably update it.
-- ===========================================================================

vim.opt.formatoptions = {
  r = true, -- continue comments by default
  o = true, -- continue comment using o or O
  n = true, -- recognize numbered lists
  q = true, -- allow gq to format comments
  a = false, -- auto-gq on type in comments?
  l = false, -- break lines that are already long?
  ['1'] = true, -- Break before 1-letter words
  ['2'] = true, -- Use indent from 2nd line of a paragraph
}

-- ===========================================================================
-- whitespace
-- ===========================================================================

vim.o.wrap = false
vim.o.joinspaces = false -- J command doesn't add extra space

-- ===========================================================================
-- indenting - overridden by indent plugins
-- ===========================================================================

-- for autoindent, use same spaces/tabs mix as previous line, even if
-- tabs/spaces are mixed. Helps for docblock, where the block comments have
-- a space after the indent to align asterisks
--
-- The test case what happens when using o/O and >> and << on these:
--
--     /**
--      *
--
-- Refer also to formatoptions+=o (copy comment indent to newline)
vim.o.copyindent = false

-- try not to change the indent structure on "<<" and ">>" commands. I.e. keep
-- block comments aligned with space if there is a space there.
vim.o.preserveindent = false

-- smart detect when in braces and parens. Has annoying side effect that it
-- won't indent lines beginning with '#'. Relying on syntax indentexpr
-- instead. 'smartindent' in general is a piece of garbage, never turn it on.
vim.o.smartindent = false

-- global setting. i don't edit C-style code all the time so don't default to
-- C-style indenting.
vim.o.cindent = false

-- ===========================================================================
-- tabbing - overridden by editorconfig, after/ftplugin
-- ===========================================================================

-- use multiple of shiftwidth when shifting indent levels.
-- this is OFF so block comments don't get fudged when using ">>" and "<<"
vim.o.shiftround = false

-- ===========================================================================
-- match and search
-- ===========================================================================

vim.o.matchtime = 1 -- tenths of a sec
vim.o.showmatch = true -- briefly jump to matching paren?
vim.o.wrapscan = true -- Searches wrap around end of the file.
vim.o.ignorecase = true
vim.o.smartcase = true
-- Follow smartcase and ignorecase when doing tag search
vim.o.tagcase = 'followscs'
