---@brief
---
--- https://github.com/alisonjenkins/terraform-ls-rs
---
--- Rust implementation of the Terraform / OpenTofu language server.
--- Install: cargo install --git https://github.com/alisonjenkins/terraform-ls-rs --bin tfls --bin tfls-lint
---
--- Settings can be set via `init_options`, live via `settings`
--- (workspace/didChangeConfiguration), or per-repo via a checked-in `.tfls.json`.
return {
  cmd = { 'tfls' },
  filetypes = { 'terraform', 'terraform-vars' },
  -- Root at the nearest Terraform module (not the repo root), so each module
  -- in a monorepo gets its own tfls instance.
  root_dir = function(bufnr, on_dir)
    local root_files = { 'versions.tf', 'main.tf', 'providers.tf', '.terraform.lock.hcl', '.terraform', '.git' }
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(vim.fs.root(bufnr, root_files) or vim.fs.dirname(fname))
  end,
  init_options = {
    ['terraform-ls-rs'] = {
      -- Defaults to `tofu`; we use terraform (managed by mise).
      cliBinary = 'terraform',
    },
  },
}
