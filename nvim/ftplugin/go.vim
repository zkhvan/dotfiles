" ftplugin/go.vim

call kz#FourTabs()
set formatoptions+=c

if kzplug#IsLoaded('nvim-treesitter')
  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()

  lua vim.api.nvim_set_hl(0, "@constructor.go", { link = "Function" })
  lua vim.api.nvim_set_hl(0, "@function.builtin.go", { link = "Function" })
endif
