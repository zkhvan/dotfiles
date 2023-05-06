" plugin/plug-vim-hr.vim

if !kzplug#IsLoaded('vim-hr') | finish | endif

call hr#map('_')
call hr#map('-')
call hr#map('=')
call hr#map('#')
call hr#map('*')
