local M = {}

local map = vim.keymap.set

map("n", "<Esc><Esc>", function()
  vim.cmd.doautoall("User EscEscStart")
  -- Clear / search term
  vim.fn.setreg("/", "")
  -- Stop highlighting searches
  vim.cmd.nohlsearch()
  vim.cmd.redraw({ bang = true })
  vim.cmd.doautoall("User EscEscEnd")
end, { desc = "Clear UI" })

-- ===========================================================================
-- Window / Buffer manip
-- ===========================================================================

map("n", "]t", vim.cmd.tabn, { desc = "Next tab" })
map("n", "[t", vim.cmd.tabp, { desc = "Prev tab" })

map("n", "<BS>", function()
  -- only in non-floating
  if vim.api.nvim_win_get_config(0).relative == "" then
    return "<C-^>"
  end
end, {
  expr = true,
  desc = "Prev buffer with <BS> backspace in normal (C-^ is kinda awkward)",
})

-- ===========================================================================
-- Diagnostic mappings
-- ===========================================================================

map("n", "[d", function()
  vim.diagnostic.goto_prev({})
end, { desc = "Go to prev diagnostic and open float" })
map("n", "]d", function()
  vim.diagnostic.goto_next({})
end, { desc = "Go to next diagnostic and open float" })
map("n", "<Leader>d", function()
  vim.diagnostic.open_float()
end, { desc = "Open diagnostic float at cursor" })

-- ===========================================================================
-- Treesitter utils
-- ===========================================================================

map("n", "ss", function()
  vim.print(vim.treesitter.get_captures_at_cursor())
end, { desc = "Print treesitter captures under cursor" })

-- ===========================================================================
-- Buffer: Edit contents
-- ===========================================================================

for _, v in ipairs({ '=', '-', '*', '#' }) do
  map('i', '<Leader>f' .. v, function()
    require('kz.utils.hr').fill(v)
  end, { desc = 'Fill horizontal line for: ' .. v })
end

-- ===========================================================================
-- telescope.nvim
-- ===========================================================================

M.bind_telescope = function()
  local t = require('telescope')
  local tb = require('telescope.builtin')

  map('n', '<Leader>ge', function()
    if t.extensions.file_browser then
      t.extensions.file_browser.file_browser({
        hidden = true, -- show hidden
      })
    end
  end, { desc = 'Telescope: open file explorer' })

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
    })
    return true
  end
  return false
end

-- LspAttach autocmd callback
---@param bufnr number
M.bind_lsp = function(bufnr)
  ---@param opts table
  ---@return table opts with silent and buffer set
  local function lsp_opts(opts)
    opts.silent = true
    opts.buffer = bufnr
    return opts
  end

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

  map({ 'n', 'i' }, '<C-g>', function()
    vim.lsp.buf.signature_help()
  end, lsp_opts({ desc = 'LSP signature_help' }))

  map('n', '<Leader>D', function()
    return telescope_builtin('lsp_type_definitions')
        or vim.lsp.buf.type_definition()
  end, lsp_opts({ desc = 'LSP type_definition' }))

  map('n', '<Leader>rn', function()
    vim.lsp.buf.rename()
  end, lsp_opts({ desc = 'LSP rename' }))

  map('n', '<Leader><Leader>', function()
    vim.lsp.buf.code_action()
  end, lsp_opts({ desc = 'LSP Code Action' }))

  map('n', 'gr', function()
    return telescope_builtin('lsp_references')
        ---@diagnostic disable-next-line: missing-parameter
        or vim.lsp.buf.references()
  end, lsp_opts({ desc = 'LSP references' }))

  map('n', '<A-=>', function()
    vim.lsp.buf.format()
  end, lsp_opts({ desc = 'LSP format' }))
end

-- ===========================================================================
-- nvim-tree
-- ===========================================================================

M.bind_nvimtree = function()
  map(
    'n',
    '<Leader>no',
    '<cmd>NvimTreeFocus<CR>',
    { desc = 'nvim-tree: focus' }
  )
  map(
    'n',
    '<Leader>nf',
    '<cmd>NvimTreeFindFile<CR>',
    { desc = 'nvim-tree: find current file' }
  )
end

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

return M