" autoload/kzplug/install.vim

function! kzplug#install#Install() abort
  execute 'silent !curl -fLo '
        \ . g:kz#vim_dir . '/autoload/plug.vim '
        \ . 'https://raw.githubusercontent.com/'
        \ . 'junegunn/vim-plug/master/plug.vim'
endfunction
