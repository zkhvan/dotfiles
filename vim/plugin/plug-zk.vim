" plugin/plug-vimspector.vim

if !kzplug#Exists('zk-nvim') | finish | endif

augroup kzzknvim
  autocmd!
augroup END

let s:cpo_save = &cpoptions
set cpoptions&vim

lua << EOF
local os = require("os")
local zk = require("zk")
local commands = require("zk.commands")

zk.setup({
  -- can be "telescope", "fzf" or "select" (`vim.ui.select`)
  -- it's recommended to use "telescope" or "fzf"
  picker = "fzf",

  lsp = {
    -- `config` is passed to `vim.lsp.start_client(config)`
    config = {
      cmd = { "zk", "lsp" },
      name = "zk",
      -- on_attach = ...
      -- etc, see `:h vim.lsp.start_client()`
    },

    -- automatically attach buffers in a zk notebook that match the given filetypes
    auto_attach = {
      enabled = true,
      filetypes = { "markdown" },
    },
  },
})

commands.add("ZkDaily", function(options)
  local date = os.date("%Y-%m-%d")
  options = vim.tbl_extend("force", { title = date, template = "daily-journal.md" }, options or {})
  zk.new(options)
end)
EOF

let &cpoptions = s:cpo_save
unlet s:cpo_save
