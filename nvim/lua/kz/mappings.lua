local M = {}

local map = vim.keymap.set
local unmap = vim.keymap.del

-- Fix common typos
vim.cmd([[
    cnoreabbrev W! w!
    cnoreabbrev Q! q!
    cnoreabbrev Qa! qa!
    cnoreabbrev Qall! qall!
    cnoreabbrev Wa wa
    cnoreabbrev Wq wq
    cnoreabbrev wQ wq
    cnoreabbrev WQ wq
    cnoreabbrev W w
    cnoreabbrev Q q
    cnoreabbrev Qa qa
    cnoreabbrev Qall qall
]])

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
-- Window / Buffer manip
-- ===========================================================================

map('n', ']t', vim.cmd.tabn, { desc = 'Next tab' })
map('n', '[t', vim.cmd.tabp, { desc = 'Prev tab' })

map('n', '<BS>', function()
  -- only in non-floating
  if vim.api.nvim_win_get_config(0).relative == '' then
    return '<C-^>'
  end
end, {
  expr = true,
  desc = 'Prev buffer with <BS> backspace in normal (C-^ is kinda awkward)',
})

-- ===========================================================================
-- Diagnostic mappings
-- ===========================================================================

map('n', '[d', function()
  vim.diagnostic.goto_prev({})
end, { desc = 'Go to prev diagnostic and open float' })
map('n', ']d', function()
  vim.diagnostic.goto_next({})
end, { desc = 'Go to next diagnostic and open float' })
map('n', '<Leader>d', function()
  vim.diagnostic.open_float()
end, { desc = 'Open diagnostic float at cursor' })

-- ===========================================================================
-- Treesitter utils
-- ===========================================================================

map('n', 'ss', function()
  vim.print(vim.treesitter.get_captures_at_cursor())
end, { desc = 'Print treesitter captures under cursor' })

-- ===========================================================================
-- Buffer: Edit contents
-- ===========================================================================

for _, v in ipairs({ '=', '-', '*', '#' }) do
  map('i', '<Leader>f' .. v, function()
    require('kz.utils.hr').fill(v)
  end, { desc = 'Fill horizontal line for: ' .. v })
end

-- ===========================================================================
-- Notes
-- ===========================================================================
map('n', '<Leader>zd', '<cmd>ZkDaily<CR>')
map('n', '<Leader>zw', '<cmd>ZkWeekly<CR>')
map('n', '<Leader>1', '<cmd>ZkInbox<CR>')
map('n', '<Leader>2', '<cmd>ZkNext<CR>')
map('n', '<Leader>3', '<cmd>ZkWaiting<CR>')
map('n', '<Leader>4', '<cmd>ZkProjects<CR>')
map('n', '<Leader>5', '<cmd>ZkSomeday<CR>')

-- ===========================================================================
-- fugitive
-- ===========================================================================

vim.cmd([[
  nnoremap <special>    glx     :0GBrowse<CR>
  vnoremap <special>    glx     :GBrowse<CR>
  xnoremap <special>    glx     :GBrowse<CR>

  nnoremap <special>    gly     :<C-U>0GBrowse!<CR>
  vnoremap <special>    gly     :GBrowse!<CR>
  xnoremap <special>    gly     :GBrowse!<CR>

  nnoremap <special>    glY     :<C-U>execute 'GBrowse! @:' . expand('%:p:h')<CR>
]])

-- ===========================================================================
-- open in...
-- ===========================================================================

map('n', 'goc', function()
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  vim.fn.system({
    'cursor',
    '--new-window',
    '--goto',
    current_file .. ':' .. current_line,
  })
end, { desc = 'open in: cursor' })

-- ===========================================================================
-- telescope.nvim
-- ===========================================================================

M.bind_telescope = function()
  local tb = require('telescope.builtin')

  map('n', '<Leader>gc', function()
    tb.find_files({
      hidden = true,
      layout_strategy = 'vertical',
    })
  end, { desc = 'Telescope: files in cwd' })

  map('n', '<Leader>gf', function()
    -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#falling-back-to-find_files-if-git_files-cant-find-a-git-directory
    vim.fn.system({ 'git', 'rev-parse', '--is-inside-work-tree' })
    local res = vim.v.shell_error == 0
    if res then
      tb.git_files({
        layout_strategy = 'vertical',
        show_untracked = true,
      })
    else
      tb.find_files({
        hidden = true,
        layout_strategy = 'vertical',
      })
    end
  end, { desc = 'Telescope: files in git work files or CWD' })

  map('n', '<Leader>gF', function()
    -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#falling-back-to-find_files-if-git_files-cant-find-a-git-directory
    vim.fn.system({ 'git', 'rev-parse', '--is-inside-work-tree' })
    local res = vim.v.shell_error == 0
    if res then
      tb.git_files({
        layout_strategy = 'vertical',
        show_untracked = true,
        git_command = { 'git', 'ls-files', '--cached' },
      })
    else
      tb.find_files({
        hidden = true,
        layout_strategy = 'vertical',
      })
    end
  end, { desc = 'Telescope: files in git work files or CWD' })

  map('n', '<Leader>gg', function()
    tb.live_grep({ layout_strategy = 'vertical' })
  end, { desc = 'Telescope: live grep CWD' })

  map('n', '<Leader>go', function()
    tb.oldfiles({ layout_strategy = 'vertical' })
  end, { desc = 'Telescope: pick from previously opened files' })

  map('n', '<Leader>gp', function()
    tb.find_files({
      hidden = true,
      layout_strategy = 'vertical',
      prompt_title = "Files in buffer's project",
      cwd = require('kz.project').root(),
    })
  end, {
    desc = 'Telescope: pick from files in current project root',
  })

  map('n', '<Leader>gP', function()
    tb.find_files({
      hidden = true,
      layout_strategy = 'vertical',
      prompt_title = "Files in buffer's project",
      no_ignore = true,
      cwd = require('kz.project').root(),
    })
  end, {
    desc = 'Telescope: pick from files in current project root',
  })

  map('n', '<Leader>gr', function()
    tb.resume()
  end, { desc = 'Telescope: re-open last picker' })

  map('n', '<Leader>gs', function()
    tb.git_status({ layout_strategy = 'vertical' })
  end, { desc = 'Telescope: pick from git status files' })
end

-- ===========================================================================
-- Buffer: LSP integration
-- ===========================================================================

---@param method string
---@return boolean -- true if telescope was succesfully called
local function telescope_builtin(method)
  local ok, builtin = pcall(require, 'telescope.builtin')
  if ok then
    builtin[method]({
      -- always show in picker so i can choose how to open it (e.g. split,
      -- vsplit)
      jump_type = 'never',
      layout_strategy = 'vertical',
      fname_width = 50,
    })
    return true
  end
  return false
end

-- LspAttach autocmd callback
---@param bufnr number
M.bind_lsp = function(bufnr)
  local conform = require('conform')

  ---@param opts table
  ---@return table opts with silent and buffer set
  local function lsp_opts(opts)
    opts.silent = true
    opts.buffer = bufnr
    return opts
  end

  -- unmap('n', 'grr', lsp_opts({}))
  -- unmap('n', 'gri', lsp_opts({}))
  -- unmap({ 'x', 'n' }, 'gra', lsp_opts({}))
  -- unmap('n', 'grn', lsp_opts({}))

  map('n', 'gD', function()
    vim.lsp.buf.declaration()
  end, lsp_opts({ desc = 'LSP declaration' }))

  map('n', 'gd', function()
    return telescope_builtin('lsp_definitions') or vim.lsp.buf.definition()
  end, lsp_opts({ desc = 'LSP definition' }))

  map('n', 'gi', function()
    return telescope_builtin('lsp_implementations')
      or vim.lsp.buf.implementation()
  end, lsp_opts({ desc = 'LSP implementation' }))

  map('n', 'K', function()
    vim.lsp.buf.hover({
      border = 'rounded',
      max_width = 80,
      silent = true,
    })
  end, lsp_opts({ desc = 'LSP hover' }))

  map({ 'n', 'i' }, '<C-g>', function()
    vim.lsp.buf.signature_help({
      border = 'rounded',
      max_width = 80,
      silent = true,
    })
  end, lsp_opts({ desc = 'LSP signature_help' }))

  map('n', 'gt', function()
    return telescope_builtin('lsp_type_definitions')
      or vim.lsp.buf.type_definition()
  end, lsp_opts({ desc = 'LSP type_definition' }))

  map('n', '<Leader>rn', function()
    vim.lsp.buf.rename()
  end, lsp_opts({ desc = 'LSP rename' }))

  map({ 'n', 's', 'v', 'x' }, '<Leader><Leader>', function()
    vim.lsp.buf.code_action()
  end, lsp_opts({ desc = 'LSP Code Action' }))

  map('n', 'gr', function()
    return telescope_builtin('lsp_references')
      ---@diagnostic disable-next-line: missing-parameter
      or vim.lsp.buf.references()
  end, lsp_opts({ desc = 'LSP references', nowait = true }))

  map('n', '<A-=>', function()
    conform.format()
  end, lsp_opts({ desc = 'LSP format' }))

  map('n', '<Leader>gt', function()
    return telescope_builtin('lsp_dynamic_workspace_symbols')
  end, lsp_opts({ desc = 'LSP dynamic_workspace_symbols' }))

  map('n', '<Leader>gd', function()
    return telescope_builtin('lsp_document_symbols')
  end, lsp_opts({ desc = 'LSP document_symbols' }))
end

-- ===========================================================================
-- nvim-tree
-- ===========================================================================

-- M.bind_nvimtree = function()
--   map(
--     'n',
--     '<Leader>no',
--     '<cmd>NvimTreeFocus<CR>',
--     { desc = 'nvim-tree: focus' }
--   )
--   map(
--     'n',
--     '<Leader>nf',
--     '<cmd>NvimTreeFindFile<CR>',
--     { desc = 'nvim-tree: find current file' }
--   )
-- end

-- ===========================================================================
-- git-signs
-- ===========================================================================

M.bind_gitsigns = function(bufnr)
  local gitsigns = require('gitsigns')

  local function bufmap(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    map(mode, l, r, opts)
  end

  -- Navigation
  bufmap('n', ']h', function()
    if vim.wo.diff then
      return ']h'
    end
    vim.schedule(function()
      gitsigns.next_hunk()
    end)
    return '<Ignore>'
  end, { expr = true, desc = 'Next hunk' })

  bufmap('n', '[h', function()
    if vim.wo.diff then
      return '[h'
    end
    vim.schedule(function()
      gitsigns.prev_hunk()
    end)
    return '<Ignore>'
  end, { expr = true, desc = 'Prev hunk' })

  -- Action
  bufmap('n', 'gb', function()
    gitsigns.blame_line()
  end, { desc = 'Popup blame for line' })
  bufmap('n', 'gB', function()
    gitsigns.blame_line({ full = true })
  end, { desc = 'Popup full blame for line' })

  -- Text object
  bufmap({ 'o', 'x' }, 'ih', '<Cmd>Gitsigns select_hunk<CR>', {
    desc = 'Select hunk',
  })
end

-- ===========================================================================
-- mini.move
-- ===========================================================================

M.mini_move = {
  -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
  left = '<C-h>',
  right = '<C-l>',
  down = '<C-j>',
  up = '<C-k>',

  -- Move current line in Normal mode
  line_left = '<C-h>',
  line_right = '<C-l>',
  line_down = '<C-j>',
  line_up = '<C-k>',
}

-- ===========================================================================
-- urlview
-- ===========================================================================

M.urlview = {
  prev = '[u',
  next = ']u',
  toggle = '<Leader>gu',
  toggle_lazy = '<Leader>gU',
}

M.bind_urlview = function()
  require('urlview').setup({
    jump = {
      prev = M.urlview.prev,
      next = M.urlview.next,
    },
  })
  map('n', M.urlview.toggle, '<Cmd>UrlView<CR>', { desc = 'Open URLs' })
  map(
    'n',
    M.urlview.toggle_lazy,
    '<Cmd>UrlView lazy<CR>',
    { desc = 'Open lazy.nvim URLs' }
  )
end

-- ===========================================================================
-- vim-textobj-user
-- ===========================================================================

M.bind_textobj = function()
  local function textobjMap(obj, char)
    char = char or obj:sub(1, 1)
    map(
      { 'o', 'x' },
      'a' .. char,
      '<Plug>(textobj-' .. obj .. '-a)',
      { desc = 'textobj: around ' .. obj }
    )
    map(
      { 'o', 'x' },
      'i' .. char,
      '<Plug>(textobj-' .. obj .. '-i)',
      { desc = 'textobj: inside ' .. obj }
    )
  end

  textobjMap('paste', 'P')
  textobjMap('url')
end

-- ===========================================================================
-- nvim-various-textobjs
-- ===========================================================================

M.bind_nvim_various_textobjs = function()
  map({ 'o', 'x' }, 'ai', function()
    ---@type 'inner'|'outer' exclude the startline
    local START = 'outer'
    ---@type 'inner'|'outer' exclude the endline
    local END = 'outer'
    ---@type 'withBlanks'|'noBlanks'
    local BLANKS = 'noBlanks'
    require('various-textobjs').indentation(START, END, BLANKS)
    vim.cmd.normal('$') -- jump to end of line like vim-textobj-indent
  end, { desc = 'textobj: indent' })

  map({ 'o', 'x' }, 'ii', function()
    ---@type 'inner'|'outer' exclude the startline
    local START = 'inner'
    ---@type 'inner'|'outer' exclude the endline
    local END = 'inner'
    ---@type 'withBlanks'|'noBlanks'
    local BLANKS = 'noBlanks'
    require('various-textobjs').indentation(START, END, BLANKS)
    vim.cmd.normal('$') -- jump to end of line like vim-textobj-indent
  end, { desc = 'textobj: indent' })

  map(
    { 'o', 'x' },
    'ik',
    "<cmd>lua require('various-textobjs').key(true)<CR>",
    { desc = 'textobj: object key' }
  )
  map(
    { 'o', 'x' },
    'iv',
    "<cmd>lua require('various-textobjs').value(true)<CR>",
    { desc = 'textobj: object value' }
  )
  map(
    { 'o', 'x' },
    'is',
    "<cmd>lua require('various-textobjs').subword(true)<CR>",
    { desc = 'textobj: camel-_Snake' }
  )

  -- replaces netrw's gx
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
-- zk.nvim
-- ===========================================================================

---@param client vim.lsp.Client
---@param bufnr integer
---@diagnostic disable-next-line: unused-local
function M.bind_zk_lsp(client, bufnr)
  local zk = require('zk')

  map('n', '<Leader>gn', '<cmd>ZkNotes { sort = { "modified" } }<CR>')
  map('n', '<Leader>gt', '<cmd>ZkTags<CR>')
  map('n', '<Leader>gb', '<cmd>ZkBacklinks<CR>')
  map('n', '<Leader>gl', '<cmd>ZkLinks<CR>')

  map('n', '<Leader>zn', function()
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
    '<leader>znt',
    ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>"
  )
  -- Create a new note in the same directory as the current buffer, using the current selection for note content and asking for its title.
  map(
    'v',
    '<leader>znc',
    ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>"
  )

  map('n', '<Leader>mn', function()
    local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':~')
    local relative = vim.fn.fnamemodify(path, ':~:.') or ''
    local url_path = vim.fn.fnamemodify(relative, ':r')

    vim.system({
      'open',
      ('http://localhost:10000/%s'):format(url_path),
    })
  end)
end

-- ===========================================================================
-- oil.nvim
-- ===========================================================================

function M.bind_oil()
  map('n', '-', '<cmd>Oil<CR>', { desc = 'Open parent directory' })
end

-- ===========================================================================
-- conform.nvim
-- ===========================================================================

function M.bind_conform()
  local conform = require('conform')
  map('n', '<A-=>', function()
    conform.format()
  end)
end

-- ===========================================================================
-- treesj
-- ===========================================================================

function M.bind_treesj()
  local tsj = require('treesj')
  map('n', '<Leader>jj', function()
    tsj.join()
  end)

  map('n', '<Leader>js', function()
    tsj.split()
  end)

  map('n', '<Leader>jm', function()
    tsj.toggle()
  end)
end

-- ===========================================================================
-- mkdnflow.nvim
-- ===========================================================================

function M.bind_mkdnflow()
  map('n', '<C-Space>', '<cmd>MkdnToggleToDo<CR>')
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
-- nvim-snippy
-- ===========================================================================

function M.bind_snippy()
  local snippy_ok, snippy = pcall(require, 'snippy')
  if snippy_ok then
    local cmp = require('cmp')
    map({ 'i', 's' }, '<C-b>', function()
      if snippy.can_jump(-1) then
        snippy.previous()
      end
      -- DO NOT FALLBACK (i.e. do not insert ^B)
    end, { desc = 'snippy: previous field' })

    map({ 'i', 's' }, '<C-f>', function()
      -- If a snippet is highlighted in PUM, expand it
      if cmp.confirm({ select = false }) then
        return
      end
      -- If in a snippet, jump to next field
      if snippy.can_expand_or_advance() then
        snippy.expand_or_advance()
        return
      end
    end, {
      desc = 'snippy: expand or next field',
    })
  end
end

-- ===========================================================================
-- render-markdown.nvim
-- ===========================================================================

function M.bind_render_markdown()
  local rm = require('render-markdown')
  local rms = require('render-markdown.state')
  map('n', '<Leader>mr', function()
    local enabled = rms.enabled
    if enabled then
      rm.disable()
    else
      rm.enable()
    end
  end, { desc = 'render-markdown: toggle' })
end

-- ===========================================================================
-- vim-dadbod-ui
-- ===========================================================================

---@param args vim.api.keyset.create_autocmd.callback_args
function M.bind_dadbod_ui(args)
  map({ 'n', 'v' }, '<CR>', '<Plug>(DBUI_ExecuteQuery)', {
    buffer = args.buf,
    desc = 'DBUI: execute query',
  })
end

return M
