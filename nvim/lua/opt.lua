vim.o.clipboard = 'unnamedplus'

-- Bumped '100 to '1000 to save more previous files
-- Bumped <50 to <100 to save more register lines
-- Bumped s10 to s100 for to allow up to 100kb of data per item
vim.o.shada = "!,'1000,<100,s100,h"

-- New neovim feature, it's like vim-over but hides the thing being replaced
-- so it is not practical for now (makes it harder to remember what you're
-- replacing/reference previous regex tokens). Default is off, but explicitly
-- disabled here, too.
-- https://github.com/neovim/neovim/pull/5226
vim.o.inccommand = ''

-- Pretty quick... errorprone on old vim so only apply to nvim
vim.o.updatetime = 250

-- Prior versions are super dangerous
if not vim.fn.has('patch-8.1.1365') and not vim.fn.has('nvim-0.3.6') then
  vim.o.modeline = false
else
  if vim.fn.exists('+modelines') then
    vim.o.modelines = 1
  end
end

if vim.fn.exists('pyxversion') and vim.fn.has('python3') then
  vim.o.pyxversion = 3
end

-- ===========================================================================
-- Display
-- ===========================================================================

vim.o.title = true -- wintitle = filename - vim

-- no beeps or flashes
vim.o.visualbell = false
vim.o.errorbells = false

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
vim.o.signcolumn = 'auto:1-4'

vim.o.synmaxcol = 512 -- don't syntax highlight long lines

vim.o.showtabline = 0 -- start OFF, toggle =2 to show tabline
vim.o.laststatus = 2  -- always show all statuslines

-- This is slow on some terminals and often gets hidden by msgs so leave it off
vim.o.showcmd = false
vim.o.showmode = false -- don't show -- INSERT -- in cmdline

-- ===========================================================================
-- Input
-- ===========================================================================

-- Enable mouse
vim.o.mouse = 'a'

-- Typing key combos
vim.o.timeout = false

-- ===========================================================================
-- Wild and file globbing stuff in command mode
-- ===========================================================================

vim.o.browsedir = 'buffer' -- browse files in same dir as open file
vim.o.wildmode = 'list:longest,full'
vim.o.wildignorecase = true

-- ===========================================================================
-- File saving
-- ===========================================================================

vim.o.fileformats = 'unix,mac,dos'

-- If we have a swap conflict, FZF has issues opening the file (and doesn't
-- prompt correctly)
vim.o.swapfile = false

-- Use backup files when writing (create new file, replace old one with new
-- one)
-- Disabled for coc.nvim compat
vim.o.writebackup = false
-- but do not leave around backup.xyz~ files after that
vim.o.backup = false
-- backupcopy=yes is the default, just be explicit. We need this for
-- webpack-dev-server and hot module reloading -- preserves special file types
-- like symlinks
vim.o.backupcopy = 'yes'

-- don't create backups for these paths
vim.opt.backupskip:append('/tmp/*')
vim.opt.backupskip:append('$TMPDIR/*')
vim.opt.backupskip:append('$TMP/*')
vim.opt.backupskip:append('$TEMP/*')
-- Make Vim able to edit crontab files again.
vim.opt.backupskip:append('/private/tmp/*')
vim.opt.backupskip:append('~/.secret/*')

-- undo files
-- double slash means create dir structure to mirror file's path
vim.o.undofile = true
vim.o.undolevels = 1000
vim.o.undoreload = 10000

-- ===========================================================================
-- Built-in completion
-- ===========================================================================

-- Don't consider = symbol as part filename.
-- vim.o.isfname-==
vim.opt.isfname:remove('=')

vim.opt.complete:remove('t')           -- don't complete tags
vim.opt.completeopt:remove('longest')  -- ncm2 requirement
vim.opt.completeopt:remove('preview')  -- don't open scratch (e.g. echodoc)
vim.opt.completeopt:append('noinsert') -- ncm2 requirement
vim.opt.completeopt:append('noselect') -- ncm2 don't select first thing
vim.opt.completeopt:append('menuone')  -- show PUM, even for one thing


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

vim.o.hidden = true -- remember undo after quitting

-- reveal already opened files from the quickfix window instead of opening new
-- buffers
vim.o.switchbuf = 'useopen'

vim.o.startofline = false -- don't jump to col1 on switch buffer

-- ===========================================================================
-- Code folding
-- ===========================================================================

vim.o.foldlevel = 999     -- very high === all folds open
vim.o.foldlevelstart = 99 -- show all folds by default
vim.o.foldenable = false

-- ===========================================================================
-- Trailing whitespace
-- ===========================================================================

vim.o.list = true
vim.opt.listchars = {
  tab = '▶ ',   -- this must be two chars, see :h listchars
  trail = '·',   -- trailing spaces
  nbsp = '⣿',   -- non-breakable spaces
  extends = '»', -- show cut off when nowrap
  precedes = '«', -- show cut off when nowrap
}

-- ===========================================================================
-- Diffing
-- ===========================================================================

-- Note this is += since fillchars was defined in the window config
vim.opt.fillchars = { diff = '⣿' }
vim.opt.diffopt = {
  vertical = true, -- Use in vertical diff mode
  filler = true,   -- blank lines to keep sides aligne
  iwhite = true,   -- Ignore whitespace changes
}

-- ===========================================================================
-- Input auto-formatting (global defaults)
-- Probably need to update these in after/ftplugin too since ftplugins will
-- probably update it.
-- ===========================================================================

vim.opt.formatoptions = {
  r = true,     -- continue comments by default
  o = true,     -- continue comment using o or O
  n = true,     -- recognize numbered lists
  q = true,     -- allow gq to format comments
  a = false,    -- auto-gq on type in comments?
  l = false,    -- break lines that are already long?
  ['1'] = true, -- Break before 1-letter words
  ['2'] = true, -- Use indent from 2nd line of a paragraph
}

-- ===========================================================================
-- Whitespace
-- ===========================================================================

vim.o.wrap = false
vim.o.joinspaces = false -- J command doesn't add extra space

-- ===========================================================================
-- Indenting - overridden by indent plugins
-- ===========================================================================

-- For autoindent, use same spaces/tabs mix as previous line, even if
-- tabs/spaces are mixed. Helps for docblock, where the block comments have a
-- space after the indent to align asterisks
--
-- The test case what happens when using o/O and >> and << on these:
--
--     /**
--      *
--
-- Refer also to formatoptions+=o (copy comment indent to newline)
vim.o.copyindent = false

-- Try not to change the indent structure on "<<" and ">>" commands. I.e. keep
-- block comments aligned with space if there is a space there.
vim.o.preserveindent = false

-- Smart detect when in braces and parens. Has annoying side effect that it
-- won't indent lines beginning with '#'. Relying on syntax indentexpr instead.
-- 'smartindent' in general is a piece of garbage, never turn it on.
vim.o.smartindent = false

-- Global setting. I don't edit C-style code all the time so don't default to
-- C-style indenting.
vim.o.cindent = false

-- ===========================================================================
-- Tabbing - overridden by editorconfig, after/ftplugin
-- ===========================================================================

-- use multiple of shiftwidth when shifting indent levels.
-- this is OFF so block comments don't get fudged when using ">>" and "<<"
vim.o.shiftround = false

-- ===========================================================================
-- Match and search
-- ===========================================================================

vim.o.matchtime = 1                       -- tenths of a sec
vim.o.showmatch = true                       -- briefly jump to matching paren?
vim.o.wrapscan = true                          -- Searches wrap around end of the file.
vim.o.ignorecase = true
vim.o.smartcase = true
-- Follow smartcase and ignorecase when doing tag search
vim.o.tagcase = 'followscs'
