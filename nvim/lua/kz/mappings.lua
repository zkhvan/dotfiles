local M = {}

local map = vim.keymap.set

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
  local ok, builtin = pcall(require, "telescope.builtin")
  if ok then
    builtin[method]({
      -- always show in picker so i can choose how to open it (e.g. split,
      -- vsplit)
      jump_type = "never",
      layout_strategy = "vertical",
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

  map("n", "gD", function()
    vim.lsp.buf.declaration()
  end, lsp_opts({ desc = "LSP declaration" }))

  map("n", "gd", function()
    return telescope_builtin("lsp_definitions") or vim.lsp.buf.definition()
  end, lsp_opts({ desc = "LSP definition" }))

  map("n", "gi", function()
    return telescope_builtin("lsp_implementations")
      or vim.lsp.buf.implementation()
  end, lsp_opts({ desc = "LSP implementation" }))

  map({ "n", "i" }, "<C-g>", function()
    vim.lsp.buf.signature_help()
  end, lsp_opts({ desc = "LSP signature_help" }))

  map("n", "<Leader>D", function()
    return telescope_builtin("lsp_type_definitions")
      or vim.lsp.buf.type_definition()
  end, lsp_opts({ desc = "LSP type_definition" }))

  map("n", "<Leader>rn", function()
    vim.lsp.buf.rename()
  end, lsp_opts({ desc = "LSP rename" }))

  map("n", "<Leader><Leader>", function()
    -- don't like the UI for lspsaga
    --vim.cmd.Lspsaga("code_action")
    vim.lsp.buf.code_action()
  end, lsp_opts({ desc = "LSP Code Action" }))

  map("n", "gr", function()
    return telescope_builtin("lsp_references")
      ---@diagnostic disable-next-line: missing-parameter
      or vim.lsp.buf.references()
  end, lsp_opts({ desc = "LSP references" }))
end

-- ===========================================================================
-- nvim-tree
-- ===========================================================================

M.bind_nvimtree = function()
  map('n', '<Leader>no', '<cmd>NvimTreeFocus<CR>', { desc = 'nvim-tree: focus' })
  map('n', '<Leader>nf', '<cmd>NvimTreeFindFile<CR>', { desc = 'nvim-tree: find current file' })
end

return M
