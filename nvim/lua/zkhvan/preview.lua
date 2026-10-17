--- Opens the current buffer in a markdown preview.
---
--- Buffers under a registered root open in that root's external,
--- long-running preview server. Anything else falls back to
--- markdown-preview.nvim, which previews the buffer itself (so the file's
--- location doesn't matter) on an OS-assigned port.
---
--- Roots are machine-specific and registered from the machine-local config
--- (nvim/after/plugin/local.lua) via M.add_root(). Order matters: more
--- specific roots should be registered first, since the first matching root
--- wins.
local M = {}

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

--- Open the current buffer in the preview server for its root, or in
--- markdown-preview.nvim when it isn't under any registered root.
function M.open()
  local abs_path = vim.fn.resolve(vim.api.nvim_buf_get_name(0))

  for _, root in ipairs(M.roots) do
    if vim.startswith(abs_path, root.dir .. '/') then
      -- Path relative to the root, with the extension stripped.
      local url_path = vim.fn.fnamemodify(abs_path:sub(#root.dir + 2), ':r')
      vim.system({
        'open',
        ('http://127.0.0.1:%d/%s'):format(root.port, url_path),
      })
      return
    end
  end

  vim.cmd('MarkdownPreview')
end

return M
