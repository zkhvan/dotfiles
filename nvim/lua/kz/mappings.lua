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
-- nvim-tree
-- ===========================================================================

M.bind_nvimtree = function()
  map('n', '<Leader>no', '<cmd>NvimTreeFocus<CR>', { desc = 'nvim-tree: focus' })
  map('n', '<Leader>nf', '<cmd>NvimTreeFindFile<CR>', { desc = 'nvim-tree: find current file' })
end

return M
