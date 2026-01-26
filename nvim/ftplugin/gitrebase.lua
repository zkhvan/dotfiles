-- Disable auto-reindenting when moving lines in git rebase files
-- The '=' operator doesn't work well for gitrebase syntax
vim.b.minimove_config = {
  options = {
    reindent_linewise = false,
  },
}
