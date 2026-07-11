--- Opens the current buffer in a locally-served markdown preview.
---
--- Roots are machine-specific and registered from the machine-local config
--- (nvim/after/plugin/local.lua) via M.add_root(). Order matters: more
--- specific roots should be registered first, since the first matching root
--- wins.
local M = {}

--- Port used when the buffer doesn't live under any registered root.
M.default_port = 10001

--- @class zkhvan.preview.Root
--- @field dir string Absolute, symlink-resolved root directory.
--- @field port integer Port the preview server for this root listens on.

--- @type zkhvan.preview.Root[]
M.roots = {}

--- Register a preview root.
--- @param root { dir: string, port: integer } dir may contain ~ and symlinks.
function M.add_root(root)
  table.insert(M.roots, {
    -- Resolve symlinks so that e.g. a symlinked project directory is matched
    -- regardless of how the file was opened.
    dir = vim.fn.resolve(vim.fn.expand(root.dir)),
    port = root.port,
  })
end

--- Open the current buffer in the preview server for its root.
function M.open()
  local abs_path = vim.fn.resolve(vim.api.nvim_buf_get_name(0))

  local port = M.default_port
  local url_path = vim.fn.fnamemodify(abs_path, ':~:.') or ''

  for _, root in ipairs(M.roots) do
    if vim.startswith(abs_path, root.dir .. '/') then
      port = root.port
      -- Path relative to the root, with the extension stripped.
      url_path = vim.fn.fnamemodify(abs_path:sub(#root.dir + 2), ':r')
      break
    end
  end

  vim.system({
    'open',
    ('http://127.0.0.1:%d/%s'):format(port, url_path),
  })
end

return M
