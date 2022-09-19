" ftplugin/go.vim

call kz#FourTabs()

if kzplug#IsLoaded('nvim-treesitter')
  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()
endif
