local M = {}

M.PROJECT_ROOTS = {
  ".luarc.json",
  ".luarc.jsonc",
  "composer.json",
  "Gemfile",
  "justfile",
  "Makefile",
  "package.json",
  "pubspec.yaml", -- flutter / dart
  "requirements.txt",
  "stylua.toml",
  "tsconfig.json",
}

--- Look upwards dirs for a file match
--- @param patterns? table
--- @return string|nil root
M.get_root_by_patterns = function(patterns)
  patterns = patterns or M.PROJECT_ROOTS
  local bufname = vim.api.nvim_buf_get_name(0)
  local start = bufname:len() > 0 and bufname or vim.uv.cwd()
  for dir in vim.fs.parents(start) do
    for _, file in pairs(patterns) do
      local filepath = vim.fs.joinpath(dir, file)
      if vim.uv.fs_stat(filepath) then
        return dir
      end
    end
  end
  return nil
end

---@param opts? table vim.fs.find opts
---@return string|nil -- git root
M.get_git_root = function(opts)
  -- naively look upwards (doesn't work on complex things like worktrees or
  -- setting git workdir)
  local find_opts = vim.tbl_extend("force", {
    limit = 1,
    upward = true,
    type = "directory",
  }, opts or {})
  local res = vim.fs.find(".git", find_opts)
  local from_find = res[1] and vim.fn.fnamemodify(res[1], ":h") or nil
  if from_find then
    return from_find
  end

  local from_system = vim
      .fn
      .system({ "git", "rev-parse", "--show-cdup" })
      :gsub("\n", "")
  if from_system then
    return vim.fn.fnamemodify(from_system, ":p:h")
  end

  return nil
end

--- Impure function that sets up root if needed
--- @return string -- git root
M.root = function()
  if not vim.b.kz_project_root then
    vim.b.kz_project_root = M.get_root_by_patterns(M.PROJECT_ROOTS)
    vim.b.kz_project_root = vim.b.kz_project_root or M.get_git_root()
  end
  return vim.b.kz_project_root
end

return M
