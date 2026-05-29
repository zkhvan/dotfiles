local M = {}

local map = vim.keymap.set
local unmap = vim.keymap.del

-- Fix common typos
vim.cmd('cnoreabbrev W! w!')
vim.cmd('cnoreabbrev Q! q!')
vim.cmd('cnoreabbrev Qa! qa!')
vim.cmd('cnoreabbrev Qall! qall!')
vim.cmd('cnoreabbrev Wa wa')
vim.cmd('cnoreabbrev Wq wq')
vim.cmd('cnoreabbrev wQ wq')
vim.cmd('cnoreabbrev WQ wq')
vim.cmd('cnoreabbrev W w')
vim.cmd('cnoreabbrev Q q')
vim.cmd('cnoreabbrev Qa qa')
vim.cmd('cnoreabbrev Qall qall')

-- ===========================================================================
-- unmap
-- ===========================================================================

-- sleep, useless!
map('n', 'gs', function() end)

-- ===========================================================================
-- commands
-- ===========================================================================

vim.api.nvim_create_user_command('LspRestart', function()
  for _, client in ipairs(vim.lsp.get_clients()) do
    vim.lsp.stop_client(client.id, true)
  end
  vim.defer_fn(function()
    vim.cmd('edit')
  end, 100)
end, { desc = 'Restart all LSP clients' })

map(
  'n',
  '<leader>lR',
  '<cmd>LspRestart<CR>',
  { desc = 'Restart all LSP clients' }
)

-- ===========================================================================
-- clear search
-- ===========================================================================

map('n', '<Esc><Esc>', function()
  vim.cmd.doautoall('User EscEscStart')
  -- Clear / search term
  vim.fn.setreg('/', '')
  -- Stop highlighting searches
  vim.cmd.nohlsearch()
  vim.cmd.redraw({ bang = true })
  vim.cmd.doautoall('User EscEscEnd')
end, { desc = 'Clear UI' })

-- ===========================================================================
-- window / buffer manip
-- ===========================================================================

map('n', '<leader>x', function()
  vim.cmd('lclose') -- close location lsit
  vim.cmd('bprev') -- open previous buffer
  vim.cmd('bdel #') -- delete buffer
end)

map('n', ']t', vim.cmd.tabn, { desc = 'Next tab' })
map('n', '[t', vim.cmd.tabp, { desc = 'Prev tab' })

map('n', '<F13>', function()
  vim.cmd.quit()
end, { desc = 'Close window' })
map('n', '<BS>', function()
  -- only in non-floating
  if vim.api.nvim_win_get_config(0).relative == '' then
    return '<C-^>'
  end
end, {
  expr = true,
  desc = 'Prev buffer with <BS> backspace in normal (C-^ is kinda awkward)',
})

map('n', '<c-w><c-v>f', function()
  vim.cmd('vert norm <c-v><c-w>f')
end, { desc = 'Open file in vertical split' })

map('n', '<c-w><c-v>]', function()
  vim.cmd('vert norm <c-v><c-w>]')
end, { desc = 'Open tag in vertical split' })

map('n', '*', 'm`<Cmd>keepjumps normal! *``<CR>', {
  desc = "Don't jump on first * -- simpler vim-asterisk",
})

-- ---------------------------------------------------------------------------
-- resize
-- ---------------------------------------------------------------------------

map('n', '<s-up>', '<c-w>+', { desc = 'Resize up' })
map('n', '<s-down>', '<c-w>-', { desc = 'Resize down' })
map('n', '<s-left>', '<c-w><', { desc = 'Resize left' })
map('n', '<s-right>', '<c-w>>', { desc = 'Resize right' })

map('i', '<s-up>', '<cmd>norm <s-up><cr>', { desc = 'Resize up' })
map('i', '<s-down>', '<cmd>norm <s-down><cr>', { desc = 'Resize down' })
map('i', '<s-left>', '<cmd>norm <s-left><cr>', { desc = 'Resize left' })
map('i', '<s-right>', '<cmd>norm <s-right><cr>', { desc = 'Resize right' })

-- ===========================================================================
-- change directories
-- ===========================================================================

map('n', '<leader>..', function()
  vim.cmd('cd ..')
end, { desc = 'cd to parent directory' })

map('n', '<leader>cd', function()
  local path = vim.api.nvim_buf_get_name(0)
  local dir = vim.fs.dirname(path)
  vim.api.nvim_set_current_dir(dir)
end, { desc = 'cd to current buffer path' })

-- ===========================================================================
-- diagnostics
-- ===========================================================================

map('n', '[d', function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = 'Go to prev diagnostic and open float' })
map('n', ']d', function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = 'Go to next diagnostic and open float' })
map('n', '<Leader>d', function()
  vim.diagnostic.open_float()
end, { desc = 'Open diagnostic float at cursor' })

-- ===========================================================================
-- buffer: edit
-- ===========================================================================

for _, v in ipairs({ '=', '-', '*', '#' }) do
  map('i', '<Leader>f' .. v, function()
    require('zkhvan.utils.hr').fill(v)
  end, { desc = 'Fill horizontal line for: ' .. v })
end

map('x', '>', '>gv', { desc = 'Reselect visual block after indent' })
map('x', '<', '<gv', { desc = 'Reselect visual block after unindent' })

-- Prevent change operations from yanking to clipboard
map({ 'n', 'x' }, 'c', '"_c', { desc = 'Change without yanking' })
map({ 'n', 'x' }, 'C', '"_C', { desc = 'Change to end without yanking' })

map('n', '<Leader>ws', function()
  require('zkhvan.utils.whitespace').clean()
end, { desc = 'Clean whitespace in buffer' })

-- ===========================================================================
-- buffer: LSP integration
-- ===========================================================================

--- Configures LSP mappings for the buffer, these are not client specific
--- mappings, just buffer specific.
---@param bufnr number
function M.bind_lsp(bufnr)
  local snacks = require('snacks')

  ---@param opts table
  ---@return table opts with silent and buffer set
  local function lsp_opts(opts)
    opts.silent = true
    opts.buffer = bufnr
    return opts
  end

  -- Use default LSP mappings for now:
  -- CTRL-]              go to definition
  -- grr gra grn gri     go to references, code action, rename, go to implementation
  -- ]d [d CTRL-W_d      go to next/prev diagnostic, open diagnostics in float

  map('n', '<leader>gt', function()
    snacks.picker.lsp_workspace_symbols()
  end, { desc = 'Snacks: LSP workspace symbols' })

  map('n', '<leader>lr', function()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    for _, client in ipairs(clients) do
      vim.lsp.stop_client(client.id, true)
    end
    vim.defer_fn(function()
      vim.cmd('edit')
    end, 100)
  end, lsp_opts({ desc = 'Restart LSP clients' }))
end

-- ===========================================================================
-- snacks.nvim
-- ===========================================================================

function M.bind_snacks()
  local snacks = require('snacks')

  map('n', '<leader>g<space>', function()
    snacks.picker.smart()
  end, { desc = 'Snacks: smart find files' })
  map('n', '<leader>gf', function()
    snacks.picker.files({
      hidden = true,
    })
  end, { desc = 'Snacks: find files' })
  map('n', '<leader>gF', function()
    snacks.picker.files({
      prompt = 'Files (including hidden and ignored)> ',
      hidden = true,
      ignored = true,
    })
  end, { desc = 'Snacks: find files' })
  map('n', '<leader>gp', function()
    snacks.picker.projects()
  end, { desc = 'Snacks: find projects' })
  map('n', '<leader>gb', function()
    snacks.picker.buffers()
  end, { desc = 'Snacks: buffers' })
  map('n', '<leader>gg', function()
    snacks.picker.grep()
  end, { desc = 'Snacks: grep' })
  map('n', '<leader>gG', function()
    local bufdir
    if vim.bo.filetype == 'oil' then
      bufdir = require('oil').get_current_dir()
    else
      bufdir = vim.fn.expand('%:p:h')
    end
    snacks.picker.grep({ cwd = bufdir })
  end, { desc = 'Snacks: grep in buffer directory' })
  map('n', '<leader>g:', function()
    snacks.picker.command_history()
  end, { desc = 'Snacks: command history' })
  map('n', '<leader>gn', function()
    snacks.picker.notifications()
  end, { desc = 'Snacks: notification history' })
  map('n', '<leader>go', function()
    snacks.picker.recent()
  end, { desc = 'Snacks: recent' })
  map('n', '<leader>gs', function()
    snacks.picker.git_status()
  end, { desc = 'Snacks: git status' })

  map('n', '<leader>sb', function()
    snacks.picker.lines()
  end, { desc = 'Snacks: buffer lines' })
  map('n', '<leader>sB', function()
    snacks.picker.grep_buffers()
  end, { desc = 'Snacks: grep open buffers' })
  map('n', '<leader>sg', function()
    snacks.picker.grep()
  end, { desc = 'Snacks: grep' })
  map({ 'n', 'x' }, '<leader>sw', function()
    snacks.picker.grep_word()
  end, { desc = 'Snacks: visual selection or word' })
  map('n', "<leader>s'", function()
    snacks.picker.registers()
  end, { desc = 'Snacks: registers' })
  map('n', '<leader>s/', function()
    snacks.picker.search_history()
  end, { desc = 'Snacks: search History' })
  map('n', '<leader>sa', function()
    snacks.picker.autocmds()
  end, { desc = 'Snacks: autocmds' })
  map('n', '<leader>sb', function()
    snacks.picker.lines()
  end, { desc = 'Snacks: buffer Lines' })
  map('n', '<leader>sc', function()
    snacks.picker.command_history()
  end, { desc = 'Snacks: command History' })
  map('n', '<leader>sC', function()
    snacks.picker.commands()
  end, { desc = 'Snacks: commands' })
  map('n', '<leader>sd', function()
    snacks.picker.diagnostics()
  end, { desc = 'Snacks: diagnostics' })
  map('n', '<leader>sD', function()
    snacks.picker.diagnostics_buffer()
  end, { desc = 'Snacks: buffer Diagnostics' })
  map('n', '<leader>sh', function()
    snacks.picker.help()
  end, { desc = 'Snacks: help Pages' })
  map('n', '<leader>sH', function()
    snacks.picker.highlights()
  end, { desc = 'Snacks: highlights' })
  map('n', '<leader>si', function()
    snacks.picker.icons()
  end, { desc = 'Snacks: icons' })
  map('n', '<leader>sj', function()
    snacks.picker.jumps()
  end, { desc = 'Snacks: jumps' })
  map('n', '<leader>sk', function()
    snacks.picker.keymaps()
  end, { desc = 'Snacks: keymaps' })
  map('n', '<leader>sl', function()
    snacks.picker.loclist()
  end, { desc = 'Snacks: location list' })
  map('n', '<leader>sm', function()
    snacks.picker.marks()
  end, { desc = 'Snacks: marks' })
  map('n', '<leader>sM', function()
    snacks.picker.man()
  end, { desc = 'Snacks: man pages' })
  map('n', '<leader>sp', function()
    snacks.picker.lazy()
  end, { desc = 'Snacks: search for plugin spec' })
  map('n', '<leader>sq', function()
    snacks.picker.qflist()
  end, { desc = 'Snacks: quickfix list' })
  map('n', '<leader>sR', function()
    snacks.picker.resume()
  end, { desc = 'Snacks: resume' })
  map('n', '<leader>su', function()
    snacks.picker.undo()
  end, { desc = 'Snacks: undo history' })
  map('n', '<leader>uC', function()
    snacks.picker.colorschemes()
  end, { desc = 'Snacks: colorschemes' })
  map('n', '<leader>\\', function()
    snacks.scratch()
  end, { desc = 'Snacks: toggle scratch buffer' })

  Snacks.toggle({
    name = 'disable_autoformat',
    get = function()
      local bufnr = vim.api.nvim_get_current_buf()
      return vim.b[bufnr].disable_autoformat
    end,
    set = function(state)
      local bufnr = vim.api.nvim_get_current_buf()
      vim.b[bufnr].disable_autoformat = state
    end,
  }):map('<leader>uf')

  Snacks.toggle({
    name = 'disable_global_autoformat',
    get = function()
      return vim.g.disable_autoformat
    end,
    set = function(state)
      vim.g.disable_autoformat = state
    end,
  }):map('<leader>uF')
end

-- ===========================================================================
-- which-key
-- ===========================================================================

function M.bind_which_key()
  local wk = require('which-key')
  map('n', '<leader>?', function()
    wk.show({ global = false })
  end, { desc = 'Buffer Local Keymaps (which-key)' })
end

-- ===========================================================================
-- oil.nvim
-- ===========================================================================

function M.bind_oil()
  map('n', '-', '<cmd>Oil<CR>', { desc = 'Open parent directory' })
  map('n', 'yp', function()
    local oil = require('oil')
    local entry = oil.get_cursor_entry()
    if entry then
      local dir = oil.get_current_dir()
      local path = dir .. entry.name
      vim.fn.setreg('+', path)
      vim.notify('Copied: ' .. path)
    end
  end, { desc = 'Copy file path to clipboard' })
end

-- ===========================================================================
-- nvim-various-textobjs
-- ===========================================================================
function M.bind_various_textobjs()
  map('n', 'gx', function()
    -- -------------------------------------------------------------------------
    -- otherwise find nearest url
    -- -------------------------------------------------------------------------
    require('various-textobjs').url() -- select URL
    -- this works since the plugin switched to visual mode
    -- if the textobj has been found
    local textobj_url = vim.fn.mode():find('v')
    if textobj_url then
      vim.print(('found textobj_url %s'):format(textobj_url))
      -- if not found in proximity, search whole buffer via urlview.nvim instead
      -- retrieve URL with the z-register as intermediary
      vim.cmd.normal({ '"zy', bang = true })
      local url = vim.fn.getreg('z')
      require('lazy.util').open(url)
      return
    end

    -- -------------------------------------------------------------------------
    -- Popup menu of all urls in buffer
    -- -------------------------------------------------------------------------
    vim.cmd.UrlView('buffer')
  end, { desc = 'Smart URL Opener' })
end

-- ===========================================================================
-- zk-nvim
-- ===========================================================================
function M.bind_zk()
  local zk = require('zk')

  map('n', '<Leader>zn', '<cmd>ZkNotes { sort = { "modified" } }<CR>')
  map('n', '<Leader>zt', '<cmd>ZkTags<CR>')
  map('n', '<Leader>zb', '<cmd>ZkBacklinks<CR>')
  map('n', '<Leader>zl', '<cmd>ZkLinks<CR>')
  map('n', '<leader>zd', '<cmd>ZkDaily<CR>')
  map('n', '<leader>zw', '<cmd>ZkWeekly<CR>')
  map('n', '<leader>1', '<cmd>ZkInbox<CR>')
  map('n', '<leader>2', '<cmd>ZkNext<CR>')
  map('n', '<leader>3', '<cmd>ZkWaiting<CR>')
  map('n', '<leader>4', '<cmd>ZkProjects<CR>')
  map('n', '<leader>5', '<cmd>ZkSomeday<CR>')

  map('n', '<Leader>zc', function()
    vim.ui.input({ prompt = 'Title: ' }, function(title)
      if title == nil then
        return
      end

      if #title <= 0 then
        return
      end

      zk.new({ title = title })
    end)
  end)

  -- Create a new note in the same directory as the current buffer, using the current selection for title.
  map(
    'v',
    '<leader>zct',
    ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>"
  )
  -- Create a new note in the same directory as the current buffer, using the current selection for note content and asking for its title.
  map(
    'v',
    '<leader>zcc',
    ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>"
  )

  map('n', '<Leader>mn', function()
    local abs_path = vim.api.nvim_buf_get_name(0)
    local in_notes = vim.startswith(abs_path, vim.fn.expand('~/Notes'))
    local port = in_notes and 10000 or 10001

    local path = vim.fn.fnamemodify(abs_path, ':~')
    local relative = vim.fn.fnamemodify(path, ':~:.') or ''
    local url_path = in_notes and vim.fn.fnamemodify(relative, ':r') or relative

    vim.system({
      'open',
      ('http://127.0.0.1:%d/%s'):format(port, url_path),
    })
  end)
end

-- ===========================================================================
-- diffview.nvim
-- ===========================================================================
function M.bind_diffview()
  map('n', '<leader>do', '<cmd>DiffviewOpen<CR>', { desc = 'Diffview: open' })
  map('n', '<leader>dc', '<cmd>DiffviewClose<CR>', { desc = 'Diffview: close' })
  map(
    'n',
    '<leader>dh',
    '<cmd>DiffviewFileHistory %<CR>',
    { desc = 'Diffview: file history' }
  )
  map(
    'n',
    '<leader>dH',
    '<cmd>DiffviewFileHistory<CR>',
    { desc = 'Diffview: repo history' }
  )
end

-- ===========================================================================
-- octo.nvim
-- ===========================================================================
function M.bind_octo()
  map('n', '<leader>opl', '<cmd>Octo pr list<CR>', { desc = 'Octo: list PRs' })
  map(
    'n',
    '<leader>opc',
    '<cmd>Octo pr checkout<CR>',
    { desc = 'Octo: checkout PR' }
  )
  map(
    'n',
    '<leader>opb',
    '<cmd>Octo pr browser<CR>',
    { desc = 'Octo: open PR in browser' }
  )
  map(
    'n',
    '<leader>oil',
    '<cmd>Octo issue list<CR>',
    { desc = 'Octo: list issues' }
  )
  map(
    'n',
    '<leader>oic',
    '<cmd>Octo issue create<CR>',
    { desc = 'Octo: create issue' }
  )
  map('n', '<leader>os', '<cmd>Octo search<CR>', { desc = 'Octo: search' })
end

-- ===========================================================================
-- fugitive
-- ===========================================================================
function M.bind_fugitive()
  vim.cmd([[
    nnoremap <special>    glx     :0GBrowse<CR>
    vnoremap <special>    glx     :GBrowse<CR>
    xnoremap <special>    glx     :GBrowse<CR>

    nnoremap <special>    gly     :<C-U>0GBrowse!<CR>
    vnoremap <special>    gly     :GBrowse!<CR>
    xnoremap <special>    gly     :GBrowse!<CR>

    nnoremap <special>    glY     :<C-U>execute 'GBrowse! @:' . expand('%:p:h')<CR>
  ]])
end

-- ===========================================================================
-- gitsigns.nvim
-- ===========================================================================
function M.bind_gitsigns()
  local gs = require('gitsigns')

  map('n', ']c', function()
    if vim.wo.diff then
      vim.cmd.normal({ ']c', bang = true })
    else
      gs.nav_hunk('next')
    end
  end, { desc = 'Next hunk' })

  map('n', '[c', function()
    if vim.wo.diff then
      vim.cmd.normal({ '[c', bang = true })
    else
      gs.nav_hunk('prev')
    end
  end, { desc = 'Previous hunk' })

  map('n', '<leader>hs', gs.stage_hunk, { desc = 'Stage hunk' })
  map('n', '<leader>hr', gs.reset_hunk, { desc = 'Reset hunk' })
  map('v', '<leader>hs', function()
    gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
  end, { desc = 'Stage hunk (visual)' })
  map('v', '<leader>hr', function()
    gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
  end, { desc = 'Reset hunk (visual)' })

  map('n', '<leader>hS', gs.stage_buffer, { desc = 'Stage buffer' })
  map('n', '<leader>hR', gs.reset_buffer, { desc = 'Reset buffer' })
  map('n', '<leader>hp', gs.preview_hunk, { desc = 'Preview hunk' })
  map('n', '<leader>hb', function()
    gs.blame_line({ full = true })
  end, { desc = 'Blame line' })
  map('n', '<leader>hd', gs.diffthis, { desc = 'Diff this' })
  map('n', '<leader>hD', function()
    gs.diffthis('~')
  end, { desc = 'Diff this ~' })

  map(
    'n',
    '<leader>tb',
    gs.toggle_current_line_blame,
    { desc = 'Toggle current line blame' }
  )
  map('n', '<leader>td', gs.toggle_deleted, { desc = 'Toggle deleted' })

  map(
    { 'o', 'x' },
    'ih',
    ':<C-U>Gitsigns select_hunk<CR>',
    { desc = 'Select hunk' }
  )
end

-- ===========================================================================
-- neotest
-- ===========================================================================

function M.bind_neotest()
  local neotest = require('neotest')

  map('n', '<Leader>tt', function()
    neotest.run.stop()
  end, { desc = 'neotest: test terminate' })

  map('n', '<Leader>tn', function()
    neotest.run.run()
  end, { desc = 'neotest: test run nearest' })

  map('n', '<Leader>tl', function()
    neotest.run.run_last()
  end, { desc = 'neotest: test run last' })

  map('n', '<Leader>tf', function()
    neotest.run.run(vim.fn.expand('%'))
  end, { desc = 'neotest: test run file' })

  map('n', '<Leader>tA', function()
    neotest.run.run(vim.uv.cwd())
  end, { desc = 'neotest: test run all files' })

  map('n', '<Leader>tS', function()
    neotest.run.run({ suite = true })
  end, { desc = 'neotest: test run suite' })

  map('n', '<Leader>ts', function()
    neotest.summary.toggle()
  end, { desc = 'neotest: test summary' })

  map('n', '<Leader>to', function()
    neotest.output.open({ enter = true, auto_close = true })
  end, { desc = 'neotest: test output' })

  map('n', '<Leader>tO', function()
    neotest.output_panel.toggle()
  end, { desc = 'neotest: test output panel' })

  map('n', '<Leader>tc', function()
    neotest.output_panel.clear()
  end, { desc = 'neotest: test output panel' })
end

-- ===========================================================================
-- toggle-checkbox.nvim
-- ===========================================================================
function M.bind_toggle_checkbox(bufnr)
  local t = require('toggle-checkbox')
  map('n', '<CR>', function()
    t.toggle()
  end, { desc = 'Toggle checkbox', buffer = bufnr })
end

return M
