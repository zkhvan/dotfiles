" ftplugin/go.vim

call kz#FourTabs()

if kzplug#IsLoaded('nvim-treesitter')
  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()

  lua vim.api.nvim_set_hl(0, "@constructor.go", { link = "Function" })
endif
