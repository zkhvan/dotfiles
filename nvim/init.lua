-- init.lua
-- Neovim init (in place of vimrc)

-- ============================================================================
-- Settings vars
-- ============================================================================

-- Fallback for vims with no env access
vim.g.vdotdir = vim.fn.expand(vim.fn.empty('$VDOTDIR') == 1 and '$XDG_CONFIG_DIR/nvim' or '$VDOTDIR')
vim.g.vdordir = vim.fs.dirname(vim.env.MYVIMRC)

vim.g.kz_runtimepath_default = vim.o.runtimepath
vim.g.mapleader = '\\'

-- Plugin settings
vim.g.kz_autoinstall_vim_plug = vim.fn.executable('git')
vim.g.kz_use_completion = vim.fn.executable('node')
vim.g.kz_use_fzf = vim.fn.exists('&autochdir')
vim.g.kz_fzf_float = 1

-- ============================================================================
-- Settings
-- ============================================================================

require('kz.providers') -- load providers first
require('kz.opt')
require('kz.builtin-syntax')
require('kz.builtin-plugins')
require('kz.terminal')
require('kz.behaviors')

-- ----------------------------------------------------------------------------
-- Plugins: autoinstall vim-plug, define plugins, install plugins if needed
-- ----------------------------------------------------------------------------

vim.cmd([[
  if g:kz_autoinstall_vim_plug
    let s:has_plug = !empty(glob(expand(g:kz#vim_dir . '/autoload/plug.vim')))
    if !s:has_plug && executable('curl')
      " Load vim-plug and its plugins?
      call kzplug#install#Install()
      let s:has_plug = 1
    endif

    if s:has_plug
      command! PI PlugInstall
      command! PU PlugUpgrade | PlugUpdate
      let g:plug_window = 'tabnew'
      call plug#begin(g:kz#plug_absdir)
      if empty($VIMNOPLUGS) | call kzplug#plugins#LoadAll() | endif
      call plug#end()
    endif
  endif
]])

vim.api.nvim_create_user_command('CloseFloatingWindows', function(opts)
    for _, window_id in ipairs(vim.api.nvim_list_wins()) do
        -- If window is floating
        if vim.api.nvim_win_get_config(window_id).relative ~= '' then
            -- Force close if called with !
            vim.api.nvim_win_close(window_id, opts.bang)
        end
    end
end, { bang = true, nargs = 0 })

-- ============================================================================
-- Security
-- ============================================================================

-- Disallow unsafe local vimrc commands
-- Leave down here since it trims local settings
vim.o.secure = true

-- =============================================================================
